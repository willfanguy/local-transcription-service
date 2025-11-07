//
//  AppDelegate.swift
//  LocalDictation
//
//  Menu bar app delegate for Local Dictation
//

import Cocoa
import SwiftUI
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    static var shared: AppDelegate?

    var statusItem: NSStatusItem!
    var menu: NSMenu!

    // Settings
    let settings = AppSettings.shared

    // Managers
    let permissionsManager = PermissionsManager.shared
    let speechManager = SpeechRecognitionManager()
    let audioManager = AudioEngineManager()
    let hotkeyManager = HotkeyManager()
    let textInsertionManager = TextInsertionManager.shared
    let overlayController = TranscriptionOverlayController()
    let transcriptionProcessor = TranscriptionProcessor.shared

    // State
    var isRecording = false
    var transcriptionObserver: AnyCancellable?
    var settingsWindow: NSWindow?
    var testHarnessWindow: CrashTestHarnessWindowController?

    // Debug logging
    private let logger = DebugLogger.shared
    private var recordingStartTime: Date?
    private var recordingStopTime: Date?

    // Cooldown to prevent crash from rapid recording cycles
    // Testing showed crashes at 4.2 seconds, so using 5 seconds to be safe
    private let minimumCooldownSeconds = 5.0
    private var cooldownTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set shared reference for other components
        AppDelegate.shared = self

        logger.markEvent("APPLICATION_DID_FINISH_LAUNCHING")
        logger.log("Application launched, process ID: \(ProcessInfo.processInfo.processIdentifier)", level: .info)

        // Install crash handler for debugging
        logger.installCrashHandler()

        // Create status item in menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // Use SF Symbol for microphone icon
            button.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "Dictation")
            button.image?.isTemplate = true // Allow system to tint the icon
            logger.log("Menu bar status item created", level: .debug)
        }

        // Create menu
        setupMenu()

        // Delay permission check to avoid TCC crash on startup
        logger.log("Deferring permission check to avoid TCC crash", level: .info)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.logger.log("Now checking permissions", level: .info)
            // Only check microphone and accessibility first - avoid speech recognition check
            self?.permissionsManager.checkMicrophonePermission()
            self?.permissionsManager.checkAccessibilityPermission()
        }

        // Setup managers (needs permissions to be checked first)
        logger.log("Setting up managers", level: .info)
        setupManagers()

        // Log detailed status
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.logger.log("Detailed status check after launch", level: .debug)
            self.logDetailedStatus()
        }

        logger.log("Application setup complete", level: .info)
    }

    func applicationWillTerminate(_ notification: Notification) {
        logger.markEvent("APPLICATION_WILL_TERMINATE")
        logger.log("Application terminating", level: .info)

        // Cleanup
        if isRecording {
            logger.log("Recording active, stopping before termination", level: .warning)
            stopRecording()
        }
        hotkeyManager.stopMonitoring()

        logger.log("Cleanup complete, flushing logs", level: .info)
        logger.flush()
    }

    private func setupMenu() {
        menu = NSMenu()

        // Status item (non-clickable)
        let statusMenuItem = NSMenuItem(title: "Ready", action: nil, keyEquivalent: "")
        statusMenuItem.isEnabled = false
        menu.addItem(statusMenuItem)

        menu.addItem(NSMenuItem.separator())

        // Start/Stop Dictation
        menu.addItem(NSMenuItem(title: "Start Dictation", action: #selector(toggleDictation), keyEquivalent: "d"))

        menu.addItem(NSMenuItem.separator())

        // Debug: Enable Key Logger
        let debugMenuItem = NSMenuItem(title: "Debug: Log All Keys", action: #selector(toggleDebugMode), keyEquivalent: "")
        menu.addItem(debugMenuItem)

        // Debug: Crash Test Harness
        menu.addItem(NSMenuItem(title: "Debug: Crash Test Harness...", action: #selector(openTestHarness), keyEquivalent: "t"))

        // Change Hotkey
        menu.addItem(NSMenuItem(title: "Change Hotkey KeyCode...", action: #selector(changeHotkey), keyEquivalent: ""))

        // Check Status
        menu.addItem(NSMenuItem(title: "Check Status", action: #selector(checkStatus), keyEquivalent: ""))

        menu.addItem(NSMenuItem.separator())

        // Settings
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))

        // Permissions
        menu.addItem(NSMenuItem(title: "Permissions...", action: #selector(openPermissions), keyEquivalent: "p"))

        menu.addItem(NSMenuItem.separator())

        // Quit
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    private func setupManagers() {
        // Connect audio engine to speech manager
        speechManager.setAudioEngine(audioManager.engine)

        // Configure speech recognizer with user's language preference
        speechManager.setLanguage(settings.recognitionLanguage)

        // Configure hotkey manager with user's settings
        hotkeyManager.hotkeyKeyCode = settings.hotkeyKeyCode
        hotkeyManager.recordingMode = settings.recordingMode

        // Observe transcription changes and update overlay
        transcriptionObserver = speechManager.$transcriptionText
            .sink { [weak self] text in
                guard let self = self else { return }
                if self.settings.showOverlay {
                    self.overlayController.updateText(text)
                }
            }

        // Setup hotkey callbacks based on recording mode
        hotkeyManager.onHotkeyPressed = { [weak self] in
            guard let self = self else { return }
            print("[AppDelegate] Hotkey pressed")

            switch self.settings.recordingMode {
            case .hold:
                // Hold to record: start on press
                self.startRecording()
            case .toggle:
                // Toggle mode: start or stop on press
                self.toggleDictation()
            }
        }

        hotkeyManager.onHotkeyReleased = { [weak self] in
            guard let self = self else { return }

            // Only stop on release in hold mode
            if self.settings.recordingMode == .hold {
                print("[AppDelegate] Hotkey released - stopping dictation")
                self.stopRecording()
            }
        }

        // Start monitoring for hotkeys if permissions granted
        if permissionsManager.accessibilityPermissionStatus {
            hotkeyManager.startMonitoring()
            print("[AppDelegate] Hotkey monitoring started")
        } else {
            print("[AppDelegate] Accessibility permission not granted - hotkey monitoring disabled")
        }
    }

    private func updateMenuBarIcon(for state: RecordingState, withBadge badge: String? = nil) {
        guard let button = statusItem.button else { return }

        switch state {
        case .idle:
            if badge != nil {
                // Show mic with clock/timer indicator during cooldown
                button.image = NSImage(systemSymbolName: "mic.badge.clock", accessibilityDescription: "Cooldown")
            } else {
                button.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "Dictation")
            }
        case .recording:
            button.image = NSImage(systemSymbolName: "mic.circle.fill", accessibilityDescription: "Recording")
        case .error:
            button.image = NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: "Error")
        }

        button.image?.isTemplate = true
    }

    private func updateMenuStatus(_ message: String) {
        if let statusItem = menu.items.first {
            statusItem.title = message
        }
    }

    private func showCooldownFeedback(remainingTime: TimeInterval) {
        // Update menu status with countdown
        let seconds = Int(ceil(remainingTime))
        updateMenuStatus("Cooldown: \(seconds)s...")

        // Update menu bar icon to show cooldown state
        updateMenuBarIcon(for: .idle, withBadge: "⏱")

        // Start a timer to update the countdown
        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self, let lastStopTime = self.recordingStopTime else {
                timer.invalidate()
                self?.cooldownTimer = nil
                self?.updateMenuStatus("Ready")
                self?.updateMenuBarIcon(for: .idle)
                return
            }

            let elapsed = Date().timeIntervalSince(lastStopTime)
            let remaining = self.minimumCooldownSeconds - elapsed

            if remaining <= 0 {
                timer.invalidate()
                self.cooldownTimer = nil
                self.updateMenuStatus("Ready")
                self.updateMenuBarIcon(for: .idle)
            } else {
                let seconds = Int(ceil(remaining))
                self.updateMenuStatus("Cooldown: \(seconds)s...")
            }
        }
    }

    @objc private func toggleDictation() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    func startRecording() {
        logger.markEvent("START_RECORDING_CALLED")
        logger.logMethodEntry("startRecording")
        logger.log("Thread: \(Thread.isMainThread ? "Main" : "Background-\(Thread.current)")", level: .debug)

        guard !isRecording else {
            logger.log("Already recording, ignoring start request", level: .warning)
            return
        }

        // Check cooldown period to prevent crash from rapid recording cycles
        if let lastStopTime = recordingStopTime {
            let timeSinceLastRecording = Date().timeIntervalSince(lastStopTime)
            logger.log("Time since last recording: \(timeSinceLastRecording) seconds", level: .info)

            if timeSinceLastRecording < minimumCooldownSeconds {
                let remainingCooldown = minimumCooldownSeconds - timeSinceLastRecording
                logger.log("COOLDOWN: Preventing recording, \(remainingCooldown)s remaining", level: .warning)
                showCooldownFeedback(remainingTime: remainingCooldown)
                return
            }
        }

        // Check permissions
        guard permissionsManager.allPermissionsGranted else {
            logger.log("Missing permissions, showing alert", level: .warning)
            updateMenuStatus("Missing permissions")
            updateMenuBarIcon(for: .error)
            showPermissionsAlert()
            return
        }

        recordingStartTime = Date()
        logger.logStateChange("AppDelegate", from: "idle", to: "recording")

        isRecording = true
        updateMenuBarIcon(for: .recording)
        updateMenuStatus("Recording...")

        // Update menu item
        if let menuItem = menu.item(withTitle: "Start Dictation") {
            menuItem.title = "Stop Dictation"
        }

        // Show overlay if enabled in settings
        if settings.showOverlay {
            overlayController.show()
        }

        // Clear previous transcription
        speechManager.transcriptionText = ""

        // Start recognition
        logger.log("Starting speech recognition with 60 second timeout", level: .info)
        speechManager.testRecognition(duration: 60.0) // 60 seconds max

        logger.log("Recording started successfully", level: .info)
        logger.logMethodExit("startRecording")
    }

    func stopRecording() {
        logger.markEvent("STOP_RECORDING_CALLED")
        logger.logMethodEntry("stopRecording")
        logger.log("Thread: \(Thread.isMainThread ? "Main" : "Background-\(Thread.current)")", level: .debug)

        guard isRecording else {
            logger.log("Not recording, ignoring stop request", level: .warning)
            return
        }

        recordingStopTime = Date()

        // Log recording duration
        if let startTime = recordingStartTime {
            logger.logTiming("Recording session", start: startTime, end: recordingStopTime!)
        }

        logger.logStateChange("AppDelegate", from: "recording", to: "processing")

        isRecording = false
        updateMenuBarIcon(for: .idle)
        updateMenuStatus("Processing...")

        // Update menu item
        if let menuItem = menu.item(withTitle: "Stop Dictation") {
            menuItem.title = "Start Dictation"
        }

        // Hide overlay if it was shown
        if settings.showOverlay {
            overlayController.hide()
        }

        // Stop recognition with explicit autoreleasepool to force cleanup
        logger.log("Calling speechManager.stopRecognition()", level: .debug)
        let stopCallTime = Date()
        autoreleasepool {
            speechManager.stopRecognition()
        }
        logger.logTiming("speechManager.stopRecognition() call", start: stopCallTime)

        // Force additional cleanup with another autoreleasepool
        autoreleasepool {
            // This helps ensure speech framework objects are released
            logger.log("Forcing autoreleasepool drain for cleanup", level: .debug)
        }

        // Get transcribed text
        let transcribedText = speechManager.transcriptionText

        logger.log("Raw transcription (\(transcribedText.count) chars): \"\(transcribedText)\"", level: .info)

        // Clean transcription (remove filler words, fix spacing)
        let cleanedText = transcriptionProcessor.cleanTranscription(transcribedText, removeFiller: true)

        logger.log("Cleaned transcription (\(cleanedText.count) chars): \"\(cleanedText)\"", level: .info)

        // Insert text if we have any
        if !cleanedText.isEmpty {
            logger.log("Inserting text", level: .debug)
            insertTranscribedText(cleanedText)
        } else {
            logger.log("No speech detected", level: .warning)
            updateMenuStatus("No speech detected")
        }

        // Reset status after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.logger.log("Resetting status to Ready", level: .debug)
            self.updateMenuStatus("Ready")
        }

        logger.logStateChange("AppDelegate", from: "processing", to: "idle")
        logger.markEvent("RECORDING_CYCLE_COMPLETE")
        logger.logMethodExit("stopRecording")

        // Flush logs to disk for crash analysis
        logger.flush()
    }

    private func insertTranscribedText(_ text: String) {
        do {
            // Use insertion method based on user settings
            switch settings.insertionMethod {
            case .auto:
                try textInsertionManager.insertText(text)
            case .direct:
                try textInsertionManager.insertTextDirect(text)
            case .clipboard:
                textInsertionManager.insertViaClipboard(text)
            case .typing:
                textInsertionManager.insertViaKeystrokes(text)
            }

            updateMenuStatus("Text inserted successfully")
            print("[AppDelegate] Text inserted: \"\(text)\"")
        } catch {
            updateMenuStatus("Text insertion failed")
            print("[AppDelegate] Text insertion failed: \(error)")
        }
    }

    private func showPermissionsAlert() {
        let alert = NSAlert()
        alert.messageText = "Permissions Required"
        alert.informativeText = "Local Dictation requires microphone, speech recognition, and accessibility permissions to function."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open Permissions")
        alert.addButton(withTitle: "Cancel")

        if alert.runModal() == .alertFirstButtonReturn {
            openPermissions()
        }
    }

    @objc private func openSettings() {
        // If settings window already exists, just bring it to front
        if let window = settingsWindow {
            window.makeKeyAndOrderFront(nil)
            return
        }

        // Create settings window
        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)

        let window = NSWindow(contentViewController: hostingController)
        window.title = "Settings"
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.center()

        // Set as key window and order front
        window.makeKeyAndOrderFront(nil)
        window.level = .floating

        // Store reference
        settingsWindow = window

        // Clear reference when window closes
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            self?.settingsWindow = nil
        }
    }

    @objc private func openPermissions() {
        // Create permissions window
        let permissionsView = PermissionsView()
        let hostingController = NSHostingController(rootView: permissionsView)

        let window = NSWindow(contentViewController: hostingController)
        window.title = "Permissions"
        window.styleMask = [.titled, .closable]
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.level = .floating
    }

    @objc private func toggleDebugMode() {
        print("\n[AppDelegate] ===== toggleDebugMode called =====")
        print("[AppDelegate] Current debug mode: \(hotkeyManager.debugMode)")

        hotkeyManager.debugMode.toggle()

        print("[AppDelegate] New debug mode: \(hotkeyManager.debugMode)")

        // Update menu item title
        if let menuItem = menu.item(withTitle: "Debug: Log All Keys") ?? menu.item(withTitle: "Debug: Stop Logging Keys") {
            if hotkeyManager.debugMode {
                menuItem.title = "Debug: Stop Logging Keys"
                updateMenuStatus("DEBUG MODE: Press any key...")
                print("\n========================================")
                print("DEBUG MODE ENABLED")
                print("Debug mode value: \(hotkeyManager.debugMode)")
                print("Monitoring active: \(hotkeyManager.isMonitoring)")
                print("Press any key - you should see events in console")
                print("Common Fn key codes: 63, 179")
                print("========================================\n")
            } else {
                menuItem.title = "Debug: Log All Keys"
                updateMenuStatus("Ready")
                print("\n========================================")
                print("DEBUG MODE DISABLED")
                print("========================================\n")
            }
        }
    }

    @objc private func changeHotkey() {
        let alert = NSAlert()
        alert.messageText = "Change Hotkey KeyCode"
        alert.informativeText = "Current keyCode: \(hotkeyManager.hotkeyKeyCode)\n\nEnter new keyCode (use Debug mode to find it):"
        alert.alertStyle = .informational

        let inputField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        inputField.stringValue = "\(hotkeyManager.hotkeyKeyCode)"
        alert.accessoryView = inputField

        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let newKeyCode = Int(inputField.stringValue) {
                hotkeyManager.hotkeyKeyCode = newKeyCode
                print("[AppDelegate] Hotkey changed to keyCode: \(newKeyCode)")
                updateMenuStatus("Hotkey updated to \(newKeyCode)")

                // Reset after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.updateMenuStatus("Ready")
                }
            } else {
                updateMenuStatus("Invalid keyCode")
            }
        }
    }

    @objc private func checkStatus() {
        // Refresh permissions
        permissionsManager.checkAllPermissions()

        // Log status
        logDetailedStatus()

        // Try to restart monitoring if not active
        if !hotkeyManager.isMonitoring && permissionsManager.accessibilityPermissionStatus {
            print("Attempting to restart hotkey monitoring...")
            hotkeyManager.startMonitoring()
        }
    }

    private func logDetailedStatus() {
        print("\n========================================")
        print("APP STATUS CHECK")
        print("========================================")
        print("Microphone permission: \(permissionsManager.microphonePermissionStatus)")
        print("Speech permission: \(permissionsManager.speechRecognitionPermissionStatus)")
        print("Accessibility permission: \(permissionsManager.accessibilityPermissionStatus)")
        print("Accessibility trusted (raw): \(AXIsProcessTrusted())")
        print("Hotkey monitoring active: \(hotkeyManager.isMonitoring)")
        print("Hotkey keyCode: \(hotkeyManager.hotkeyKeyCode)")
        print("Debug mode: \(hotkeyManager.debugMode)")
        print("========================================\n")

        if !permissionsManager.accessibilityPermissionStatus {
            print("⚠️  ACCESSIBILITY NOT GRANTED - Hotkey detection will not work!")
            print("   Open System Settings > Privacy & Security > Accessibility")
            print("   Enable LocalDictation")

            // Show alert
            let alert = NSAlert()
            alert.messageText = "Accessibility Permission Required"
            alert.informativeText = "LocalDictation needs Accessibility permission to detect the Fn key globally.\n\nPlease grant permission in System Settings."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Open System Settings")
            alert.addButton(withTitle: "Cancel")

            if alert.runModal() == .alertFirstButtonReturn {
                permissionsManager.openAccessibilitySettings()
            }
        } else if !hotkeyManager.isMonitoring {
            print("⚠️  HOTKEY MONITORING NOT ACTIVE!")
            print("   Accessibility is granted but monitoring failed to start")
        } else {
            print("✅ All systems operational")
        }
    }

    @objc private func openTestHarness() {
        logger.log("Opening crash test harness", level: .info)

        if testHarnessWindow == nil {
            testHarnessWindow = CrashTestHarnessWindowController()
        }
        testHarnessWindow?.show()
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}

// Recording state enum
enum RecordingState {
    case idle
    case recording
    case error
}
