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
    var escapeKeyMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status item in menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // Use SF Symbol for microphone icon
            button.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "Dictation")
            button.image?.isTemplate = true // Allow system to tint the icon
        }

        // Create menu
        setupMenu()

        // Check permissions on launch (BEFORE setting up managers)
        permissionsManager.checkAllPermissions()

        // Setup managers (needs permissions to be checked first)
        setupManagers()

        // Log detailed status
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.logDetailedStatus()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Cleanup
        if isRecording {
            stopRecording()
        }
        hotkeyManager.stopMonitoring()
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
        // Audio engine will be created fresh for each recording session
        // No need to set it here - it will be set in startRecording()

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

    private func updateMenuBarIcon(for state: RecordingState) {
        guard let button = statusItem.button else { return }

        switch state {
        case .idle:
            button.image = NSImage(systemSymbolName: "mic.fill", accessibilityDescription: "Dictation")
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

    @objc private func toggleDictation() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        guard !isRecording else { return }

        // Check permissions
        guard permissionsManager.allPermissionsGranted else {
            updateMenuStatus("Missing permissions")
            updateMenuBarIcon(for: .error)
            showPermissionsAlert()
            return
        }

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

        // Get a fresh audio engine for this recording session
        let freshEngine = audioManager.getFreshEngine()
        speechManager.setAudioEngine(freshEngine)
        print("[AppDelegate] Fresh audio engine created and set")

        // Start recognition (must be on main thread for AVAudioEngine)
        do {
            try speechManager.startRecognition()
            print("[AppDelegate] Recording started")

            // Install Escape key monitor for emergency cancel
            escapeKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
                if event.keyCode == 53 { // Escape key
                    print("[AppDelegate] Escape key pressed - emergency stop")
                    self?.stopRecording()
                    return nil // Consume the event
                }
                return event
            }
        } catch {
            // Recognition failed to start
            print("[AppDelegate] Failed to start recognition: \(error)")
            updateMenuStatus("Recognition failed")
            updateMenuBarIcon(for: .error)

            // Reset state
            isRecording = false
            if settings.showOverlay {
                overlayController.hide()
            }
            if let menuItem = menu.item(withTitle: "Stop Dictation") {
                menuItem.title = "Start Dictation"
            }
        }
    }

    private func stopRecording() {
        guard isRecording else { return }

        isRecording = false

        // Remove Escape key monitor
        if let monitor = escapeKeyMonitor {
            NSEvent.removeMonitor(monitor)
            escapeKeyMonitor = nil
            print("[AppDelegate] Escape key monitor removed")
        }

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

        // Stop recognition
        speechManager.stopRecognition()

        // DON'T destroy the engine immediately - the recognitionTask completion handler
        // may still be running asynchronously with autoreleased references to engine internals.
        // The old engine will be replaced when we create a fresh one for the next recording.
        print("[AppDelegate] Audio engine stopped (will be replaced on next recording)")

        // Get transcribed text
        let transcribedText = speechManager.transcriptionText

        print("[AppDelegate] Recording stopped. Raw transcription: \"\(transcribedText)\"")

        // Clean transcription (remove filler words, fix spacing)
        let cleanedText = transcriptionProcessor.cleanTranscription(transcribedText, removeFiller: true)

        print("[AppDelegate] Cleaned transcription: \"\(cleanedText)\"")

        // Insert text if we have any
        if !cleanedText.isEmpty {
            insertTranscribedText(cleanedText)
        } else {
            updateMenuStatus("No speech detected")
        }

        // Reset status after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.updateMenuStatus("Ready")
        }
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
