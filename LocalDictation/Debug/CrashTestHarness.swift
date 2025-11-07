//
//  CrashTestHarness.swift
//  LocalDictation
//
//  Automated test harness for debugging the second-recording crash
//

import SwiftUI
import AppKit
import Combine

struct CrashTestHarness: View {
    @StateObject private var testRunner = TestRunner()
    @State private var selectedTest = TestType.rapidStartStop
    @State private var showingLogExport = false
    @State private var logOutput: String = "Test harness ready\n"
    @State private var scrollToBottom = false

    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Crash Test Harness")
                .font(.title)
                .bold()

            Text("Automated testing for second-recording crash")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()

            // Test Selection
            VStack(alignment: .leading, spacing: 10) {
                Text("Select Test Sequence:")
                    .font(.headline)

                Picker("Test Type", selection: $selectedTest) {
                    ForEach(TestType.allCases, id: \.self) { test in
                        Text(test.description).tag(test)
                    }
                }
                .pickerStyle(RadioGroupPickerStyle())
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            // Control Buttons
            HStack(spacing: 20) {
                Button(action: runTest) {
                    Label("Run Test", systemImage: "play.fill")
                        .frame(width: 120)
                }
                .disabled(testRunner.isRunning)
                .buttonStyle(.borderedProminent)

                Button(action: stopTest) {
                    Label("Stop", systemImage: "stop.fill")
                        .frame(width: 120)
                }
                .disabled(!testRunner.isRunning)
                .foregroundColor(.red)

                Button(action: clearLogs) {
                    Label("Clear Logs", systemImage: "trash")
                        .frame(width: 120)
                }
            }

            // Progress
            if testRunner.isRunning {
                VStack {
                    ProgressView(value: testRunner.progress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())

                    Text(testRunner.statusMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }

            // Log Output
            VStack(alignment: .leading) {
                HStack {
                    Text("Log Output:")
                        .font(.headline)

                    Spacer()

                    Button("Export Logs") {
                        exportLogs()
                    }
                    .disabled(logOutput.isEmpty)
                }

                ScrollViewReader { proxy in
                    ScrollView {
                        Text(logOutput)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .id("logBottom")
                    }
                    .background(Color.black.opacity(0.9))
                    .foregroundColor(.green)
                    .cornerRadius(4)
                    .frame(height: 300)
                    .onChange(of: logOutput) { _ in
                        withAnimation {
                            proxy.scrollTo("logBottom", anchor: .bottom)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            // Status
            HStack {
                Circle()
                    .fill(testRunner.hasError ? Color.red : (testRunner.isRunning ? Color.yellow : Color.green))
                    .frame(width: 10, height: 10)

                Text(testRunner.hasError ? "Error detected" : (testRunner.isRunning ? "Test running..." : "Ready"))
                    .font(.caption)

                Spacer()

                Text("Log file: \(DebugLogger.shared.currentLogPath ?? "none")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: 600, height: 700)
        .onReceive(testRunner.$logMessages) { messages in
            logOutput = messages.joined(separator: "\n")
        }
    }

    private func runTest() {
        logOutput = "Starting test: \(selectedTest.description)\n"
        testRunner.runTest(selectedTest)
    }

    private func stopTest() {
        testRunner.stopTest()
        logOutput += "\n[Test stopped by user]\n"
    }

    private func clearLogs() {
        logOutput = "Logs cleared\n"
        testRunner.clearLogs()
    }

    private func exportLogs() {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = "crash_test_logs_\(Date().timeIntervalSince1970).txt"
        savePanel.allowedContentTypes = [.plainText]

        if savePanel.runModal() == .OK, let url = savePanel.url {
            do {
                try logOutput.write(to: url, atomically: true, encoding: .utf8)
                logOutput += "\n[Logs exported to: \(url.path)]\n"
            } catch {
                logOutput += "\n[Export failed: \(error)]\n"
            }
        }
    }
}

// MARK: - Test Runner

class TestRunner: ObservableObject {
    @Published var isRunning = false
    @Published var progress: Double = 0
    @Published var statusMessage = ""
    @Published var hasError = false
    @Published var logMessages: [String] = []

    private var testTask: Task<Void, Never>?
    private let logger = DebugLogger.shared
    private let appDelegate: AppDelegate

    init() {
        // Get reference to AppDelegate via shared instance
        guard let delegate = AppDelegate.shared else {
            fatalError("AppDelegate.shared not initialized - ensure app has launched")
        }
        self.appDelegate = delegate
        logMessages.append("Test runner initialized")
    }

    func runTest(_ testType: TestType) {
        guard !isRunning else { return }

        // Check permissions before running tests
        let permissionsManager = PermissionsManager.shared
        permissionsManager.checkAllPermissions()

        guard permissionsManager.allPermissionsGranted else {
            logMessages.append("❌ ERROR: Missing permissions!")
            logMessages.append("Please grant all permissions before running tests:")
            logMessages.append("• Microphone")
            logMessages.append("• Speech Recognition")
            logMessages.append("• Accessibility")
            logMessages.append("\nGo to System Settings → Privacy & Security")
            hasError = true
            return
        }

        isRunning = true
        hasError = false
        progress = 0
        statusMessage = "Starting test..."

        logger.markEvent("TEST_HARNESS_START: \(testType.description)")
        logMessages.append("\n===== STARTING TEST: \(testType.description) =====")
        logMessages.append("Time: \(Date())")

        testTask = Task {
            await executeTest(testType)
        }
    }

    func stopTest() {
        testTask?.cancel()
        isRunning = false
        statusMessage = "Test cancelled"
        logger.markEvent("TEST_HARNESS_CANCELLED")
    }

    func clearLogs() {
        logMessages = ["Logs cleared"]
    }

    @MainActor
    private func executeTest(_ testType: TestType) async {
        let sequences = testType.sequences

        for (index, sequence) in sequences.enumerated() {
            guard !Task.isCancelled else { break }

            progress = Double(index) / Double(sequences.count)
            statusMessage = "Running sequence \(index + 1) of \(sequences.count)"

            logMessages.append("\n--- Sequence \(index + 1): \(sequence.description) ---")
            logger.markEvent("TEST_SEQUENCE_START: \(sequence.description)")

            // Execute the sequence
            await executeSequence(sequence)

            // Check for crash
            if checkForCrash() {
                hasError = true
                logMessages.append("⚠️ CRASH DETECTED!")
                logger.markEvent("CRASH_DETECTED_IN_TEST")
                break
            }

            // Delay between sequences
            if index < sequences.count - 1 {
                logMessages.append("Waiting 2 seconds before next sequence...")
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }

        isRunning = false
        progress = 1.0
        statusMessage = hasError ? "Test failed - crash detected" : "Test completed successfully"

        logger.markEvent("TEST_HARNESS_COMPLETE")
        logMessages.append("\n===== TEST COMPLETE =====")
        logMessages.append("Result: \(statusMessage)")
        logger.flush()
    }

    @MainActor
    private func executeSequence(_ sequence: TestSequence) async {
        logMessages.append("Starting recording #1...")
        appDelegate.startRecording()

        // Wait for recording duration
        logMessages.append("Recording for \(sequence.recordDuration) seconds...")
        try? await Task.sleep(nanoseconds: UInt64(sequence.recordDuration * 1_000_000_000))

        logMessages.append("Stopping recording #1...")
        appDelegate.stopRecording()

        // Wait between recordings
        logMessages.append("Waiting \(sequence.delayBetween) seconds...")
        try? await Task.sleep(nanoseconds: UInt64(sequence.delayBetween * 1_000_000_000))

        // CRITICAL: Second recording attempt
        logMessages.append("🔴 Starting recording #2 (crash point)...")
        logger.markEvent("CRITICAL_SECOND_RECORDING_ATTEMPT")

        appDelegate.startRecording()

        // If we get here, no immediate crash
        logMessages.append("✅ Second recording started without crash")

        // Record for a bit to test stability
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        logMessages.append("Stopping recording #2...")
        appDelegate.stopRecording()

        logMessages.append("Sequence completed successfully")
    }

    private func checkForCrash() -> Bool {
        // Check if app is still responding
        // In real scenario, would check for crash reports or unresponsiveness
        // For now, return false as we can't detect from within the app
        return false
    }
}

// MARK: - Test Types

enum TestType: String, CaseIterable {
    case rapidStartStop = "rapid"
    case shortRecordings = "short"
    case mediumRecordings = "medium"
    case variableDelays = "variable"
    case stressTes = "stress"

    var description: String {
        switch self {
        case .rapidStartStop:
            return "Rapid Start/Stop (immediate restart)"
        case .shortRecordings:
            return "Short Recordings (1 second each)"
        case .mediumRecordings:
            return "Medium Recordings (5 seconds each)"
        case .variableDelays:
            return "Variable Delays (0-3 seconds)"
        case .stressTes:
            return "Stress Test (10 rapid cycles)"
        }
    }

    var sequences: [TestSequence] {
        switch self {
        case .rapidStartStop:
            return [
                TestSequence(recordDuration: 2, delayBetween: 0, description: "2s record, 0s delay"),
                TestSequence(recordDuration: 1, delayBetween: 0, description: "1s record, 0s delay"),
                TestSequence(recordDuration: 0.5, delayBetween: 0, description: "0.5s record, 0s delay")
            ]

        case .shortRecordings:
            return [
                TestSequence(recordDuration: 1, delayBetween: 0.5, description: "1s record, 0.5s delay"),
                TestSequence(recordDuration: 1, delayBetween: 1, description: "1s record, 1s delay"),
                TestSequence(recordDuration: 1, delayBetween: 2, description: "1s record, 2s delay")
            ]

        case .mediumRecordings:
            return [
                TestSequence(recordDuration: 5, delayBetween: 0.5, description: "5s record, 0.5s delay"),
                TestSequence(recordDuration: 5, delayBetween: 1, description: "5s record, 1s delay"),
                TestSequence(recordDuration: 5, delayBetween: 3, description: "5s record, 3s delay")
            ]

        case .variableDelays:
            return [
                TestSequence(recordDuration: 2, delayBetween: 0, description: "2s record, 0s delay"),
                TestSequence(recordDuration: 2, delayBetween: 0.1, description: "2s record, 0.1s delay"),
                TestSequence(recordDuration: 2, delayBetween: 0.5, description: "2s record, 0.5s delay"),
                TestSequence(recordDuration: 2, delayBetween: 1, description: "2s record, 1s delay"),
                TestSequence(recordDuration: 2, delayBetween: 3, description: "2s record, 3s delay")
            ]

        case .stressTes:
            return (0..<10).map { i in
                TestSequence(recordDuration: 0.5, delayBetween: 0.1, description: "Rapid cycle \(i+1)")
            }
        }
    }
}

struct TestSequence {
    let recordDuration: TimeInterval
    let delayBetween: TimeInterval
    let description: String
}

// MARK: - Window Controller

class CrashTestHarnessWindowController: NSWindowController {
    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )

        window.title = "Crash Test Harness"
        window.center()

        let contentView = NSHostingView(rootView: CrashTestHarness())
        window.contentView = contentView

        self.init(window: window)
    }

    func show() {
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}