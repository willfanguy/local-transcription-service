//
//  ContentView.swift
//  LocalDictation
//
//  Main content view for the Local Dictation app
//

import SwiftUI
import AVFoundation
import Speech

struct ContentView: View {
    @State private var statusMessage = "Ready"
    @State private var transcriptionText = "Transcription will appear here..."
    @State private var isRecording = false

    // Managers
    @StateObject private var permissionsManager = PermissionsManager.shared
    @StateObject private var speechManager = SpeechRecognitionManager()
    @StateObject private var audioManager = AudioEngineManager()
    @StateObject private var hotkeyManager = HotkeyManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("Local Dictation")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(statusMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)

            // Transcription display
            GroupBox("Transcription") {
                ScrollView {
                    Text(speechManager.transcriptionText.isEmpty ? transcriptionText : speechManager.transcriptionText)
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                }
                .frame(height: 100)
            }

            HStack(spacing: 15) {
                // Test button for permissions
                Button("Test Permissions") {
                    testPermissions()
                }
                .buttonStyle(.borderedProminent)

                // Test 3-second recording
                Button(isRecording ? "Recording..." : "Test 3-Second Recording") {
                    test3SecondRecording()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRecording ||
                         permissionsManager.microphonePermissionStatus != .authorized ||
                         permissionsManager.speechRecognitionPermissionStatus != .authorized)
            }

            Divider()

            // Phase 4: Text Insertion Testing
            GroupBox("Text Insertion Testing (Phase 4)") {
                VStack(spacing: 10) {
                    HStack {
                        Button("Insert 'Hello World'") {
                            testTextInsertion("Hello World")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!permissionsManager.accessibilityPermissionStatus)

                        Button("Insert Transcription") {
                            let textToInsert = speechManager.transcriptionText.isEmpty ? "No transcription available" : speechManager.transcriptionText
                            testTextInsertion(textToInsert)
                        }
                        .buttonStyle(.bordered)
                        .disabled(!permissionsManager.accessibilityPermissionStatus || speechManager.transcriptionText.isEmpty)
                    }

                    Text("Click a button, then focus any text field to test insertion")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(8)
            }

            Divider()

            // Phase 3: Hotkey Testing
            GroupBox("Hotkey Testing (Phase 3)") {
                VStack(spacing: 10) {
                    HStack {
                        Text("Accessibility:")
                        Text(permissionsManager.accessibilityPermissionStatus ? "✅ Granted" : "❌ Not Granted")
                            .foregroundColor(permissionsManager.accessibilityPermissionStatus ? .green : .red)
                        Spacer()
                        if !permissionsManager.accessibilityPermissionStatus {
                            Button("Request") {
                                permissionsManager.requestAccessibilityPermission()
                            }
                            .buttonStyle(.bordered)
                            Button("Open Settings") {
                                permissionsManager.openAccessibilitySettings()
                            }
                            .buttonStyle(.bordered)
                        }
                        Button("Check Again") {
                            permissionsManager.checkAccessibilityPermission()
                        }
                        .buttonStyle(.bordered)
                    }

                    HStack {
                        Button(hotkeyManager.isMonitoring ? "Stop Monitoring" : "Start Hotkey Monitoring") {
                            toggleHotkeyMonitoring()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!permissionsManager.accessibilityPermissionStatus)

                        if hotkeyManager.isHotkeyPressed {
                            Text("🔴 Hotkey Pressed!")
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                        }
                    }

                    Text("Default hotkey: Fn key (keyCode 179)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(8)
            }

            Spacer()

            Text("Press Fn key to start dictation")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(40)
        .frame(width: 500, height: 550)
        .onAppear {
            setupManagers()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            // Re-check permissions when app becomes active (user may have granted in Settings)
            permissionsManager.checkAllPermissions()
        }
    }

    private func setupManagers() {
        // Connect audio engine to speech manager
        speechManager.setAudioEngine(audioManager.engine)

        // Check initial permissions
        permissionsManager.checkAllPermissions()

        // Setup hotkey callbacks
        hotkeyManager.onHotkeyPressed = {
            print("[ContentView] Fn key pressed callback received")
        }

        hotkeyManager.onHotkeyReleased = {
            print("[ContentView] Fn key released callback received")
        }

        if permissionsManager.allPermissionsGranted {
            statusMessage = "All permissions granted - Ready to record"
        } else {
            statusMessage = "Permissions needed - Click 'Test Permissions'"
        }
    }

    private func testPermissions() {
        print("Testing permissions...")
        statusMessage = "Requesting permissions..."

        // Request microphone permission
        permissionsManager.requestMicrophonePermission { granted in
            print("Microphone permission: \(granted)")

            // Then request speech recognition permission
            self.permissionsManager.requestSpeechRecognitionPermission { status in
                print("Speech recognition permission: \(status.rawValue)")

                // Update status message based on results
                DispatchQueue.main.async {
                    if self.permissionsManager.allPermissionsGranted {
                        self.statusMessage = "All permissions granted!"
                    } else {
                        var missing: [String] = []
                        if self.permissionsManager.microphonePermissionStatus != .authorized {
                            missing.append("Microphone")
                        }
                        if self.permissionsManager.speechRecognitionPermissionStatus != .authorized {
                            missing.append("Speech Recognition")
                        }
                        if !self.permissionsManager.accessibilityPermissionStatus {
                            missing.append("Accessibility")
                        }
                        self.statusMessage = "Missing: \(missing.joined(separator: ", "))"
                    }
                }
            }
        }
    }

    private func test3SecondRecording() {
        print("Starting 3-second test recording...")

        // Clear previous transcription
        speechManager.transcriptionText = ""
        transcriptionText = "Listening..."
        isRecording = true
        statusMessage = "Recording for 3 seconds..."

        // Use the test method from SpeechRecognitionManager
        speechManager.testRecognition(duration: 3.0)

        // Update UI after recording completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isRecording = false
            self.statusMessage = "Recording complete"

            if self.speechManager.transcriptionText.isEmpty {
                self.transcriptionText = "No speech detected. Try speaking louder or check microphone."
            }

            print("Test recording completed")
            print("Final transcription: \(self.speechManager.transcriptionText)")
        }
    }

    private func toggleHotkeyMonitoring() {
        if hotkeyManager.isMonitoring {
            hotkeyManager.stopMonitoring()
            statusMessage = "Hotkey monitoring stopped"
        } else {
            hotkeyManager.startMonitoring()
            statusMessage = "Monitoring for Fn key presses..."
        }
    }

    private func testTextInsertion(_ text: String) {
        print("Testing text insertion with: \"\(text)\"")
        statusMessage = "Inserting text..."

        let textInsertionManager = TextInsertionManager.shared

        // Give user 1 second to focus a text field
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            do {
                try textInsertionManager.insertText(text)
                self.statusMessage = "Text inserted successfully!"

                // Clear status after a few seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.statusMessage = "Ready"
                }
            } catch {
                self.statusMessage = "Text insertion failed: \(error.localizedDescription)"
                print("Text insertion error: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}