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

        // Setup managers
        setupManagers()

        // Check permissions on launch
        permissionsManager.checkAllPermissions()

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
        // Connect audio engine to speech manager
        speechManager.setAudioEngine(audioManager.engine)

        // Observe transcription changes and update overlay
        transcriptionObserver = speechManager.$transcriptionText
            .sink { [weak self] text in
                self?.overlayController.updateText(text)
            }

        // Setup hotkey callbacks
        hotkeyManager.onHotkeyPressed = { [weak self] in
            print("[AppDelegate] Fn key pressed - starting dictation")
            self?.startRecording()
        }

        hotkeyManager.onHotkeyReleased = { [weak self] in
            print("[AppDelegate] Fn key released - stopping dictation")
            self?.stopRecording()
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

        // Show overlay
        overlayController.show()

        // Clear previous transcription
        speechManager.transcriptionText = ""

        // Start recognition
        speechManager.testRecognition(duration: 60.0) // 60 seconds max

        print("[AppDelegate] Recording started")
    }

    private func stopRecording() {
        guard isRecording else { return }

        isRecording = false
        updateMenuBarIcon(for: .idle)
        updateMenuStatus("Processing...")

        // Update menu item
        if let menuItem = menu.item(withTitle: "Stop Dictation") {
            menuItem.title = "Start Dictation"
        }

        // Hide overlay
        overlayController.hide()

        // Stop recognition
        speechManager.stopRecognition()

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
            try textInsertionManager.insertText(text)
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
        // TODO: Implement settings window in Phase 6
        let alert = NSAlert()
        alert.messageText = "Settings"
        alert.informativeText = "Settings will be available in Phase 6."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
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
