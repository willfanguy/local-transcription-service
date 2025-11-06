//
//  AudioEngineManager.swift
//  LocalDictation
//
//  Manages AVAudioEngine for audio input
//

import Foundation
import AVFoundation

/// Manages the audio engine for recording
class AudioEngineManager: ObservableObject {

    // MARK: - Properties

    /// The audio engine instance
    private let audioEngine = AVAudioEngine()

    // MARK: - Published Properties

    /// Whether the audio engine is currently running
    @Published var isRunning: Bool = false

    /// Current error if any
    @Published var currentError: Error?

    // MARK: - Computed Properties

    /// Get the current audio engine (for use by SpeechRecognitionManager)
    var engine: AVAudioEngine {
        return audioEngine
    }

    /// Check if engine is currently running
    var engineIsRunning: Bool {
        return audioEngine.isRunning
    }

    // MARK: - Initialization

    init() {
        print("AudioEngineManager initialized")
        printEngineConfiguration()
    }

    // MARK: - Public Methods

    /// Start the audio engine
    func startEngine() throws {
        print("Starting audio engine...")

        if audioEngine.isRunning {
            print("Audio engine already running")
            return
        }

        do {
            // Prepare the engine
            audioEngine.prepare()

            // Start the engine
            try audioEngine.start()

            isRunning = true
            print("Audio engine started successfully")
            printEngineConfiguration()

        } catch {
            print("Failed to start audio engine: \(error.localizedDescription)")
            currentError = error
            isRunning = false
            throw error
        }
    }

    /// Stop the audio engine
    func stopEngine() {
        print("Stopping audio engine...")

        if !audioEngine.isRunning {
            print("Audio engine already stopped")
            return
        }

        audioEngine.stop()
        isRunning = false
        print("Audio engine stopped")
    }

    /// Reset the audio engine
    func resetEngine() {
        print("Resetting audio engine...")
        stopEngine()
        audioEngine.reset()
        print("Audio engine reset completed")
    }

    /// Setup audio tap for recording (called by SpeechRecognitionManager)
    func setupAudioTap(bufferSize: AVAudioFrameCount = 1024,
                      format: AVAudioFormat? = nil,
                      tapBlock: @escaping AVAudioNodeTapBlock) {

        let inputNode = audioEngine.inputNode
        let recordingFormat = format ?? inputNode.outputFormat(forBus: 0)

        // Remove any existing tap
        inputNode.removeTap(onBus: 0)

        // Install new tap
        inputNode.installTap(onBus: 0,
                            bufferSize: bufferSize,
                            format: recordingFormat,
                            block: tapBlock)

        print("Audio tap installed with buffer size: \(bufferSize)")
        print("Recording format: \(recordingFormat)")
    }

    /// Remove audio tap
    func removeAudioTap() {
        audioEngine.inputNode.removeTap(onBus: 0)
        print("Audio tap removed")
    }

    // MARK: - Private Methods

    /// Print current engine configuration for debugging
    private func printEngineConfiguration() {
        let inputNode = audioEngine.inputNode
        let outputFormat = inputNode.outputFormat(forBus: 0)

        print("=== Audio Engine Configuration ===")
        print("Running: \(audioEngine.isRunning)")
        print("Input channels: \(outputFormat.channelCount)")
        print("Sample rate: \(outputFormat.sampleRate)")
        print("Format: \(outputFormat.formatDescription)")
        print("================================")
    }

    // MARK: - Testing

    /// Test audio engine start/stop
    func testStartStop(iterations: Int = 3) {
        print("Testing audio engine start/stop (\(iterations) iterations)...")

        for i in 1...iterations {
            print("Iteration \(i):")

            do {
                try startEngine()
                Thread.sleep(forTimeInterval: 0.5)
                stopEngine()
                Thread.sleep(forTimeInterval: 0.5)
                print("Iteration \(i) completed successfully")
            } catch {
                print("Iteration \(i) failed: \(error.localizedDescription)")
                break
            }
        }

        print("Audio engine test completed")
    }

    // MARK: - Cleanup

    deinit {
        stopEngine()
        print("AudioEngineManager deinitialized")
    }
}

// MARK: - Audio Engine Errors

enum AudioEngineError: LocalizedError {
    case engineNotRunning
    case engineAlreadyRunning
    case inputNodeUnavailable
    case invalidFormat

    var errorDescription: String? {
        switch self {
        case .engineNotRunning:
            return "Audio engine is not running"
        case .engineAlreadyRunning:
            return "Audio engine is already running"
        case .inputNodeUnavailable:
            return "Input node is not available"
        case .invalidFormat:
            return "Invalid audio format"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .engineNotRunning:
            return "Start the audio engine first"
        case .engineAlreadyRunning:
            return "Stop the current session first"
        case .inputNodeUnavailable:
            return "Check microphone connection"
        case .invalidFormat:
            return "Use a supported audio format"
        }
    }
}