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

    /// The audio engine instance - created fresh for each recording session
    private var audioEngine: AVAudioEngine?

    // MARK: - Published Properties

    /// Whether the audio engine is currently running
    @Published var isRunning: Bool = false

    /// Current error if any
    @Published var currentError: Error?

    // MARK: - Computed Properties

    /// Get the current audio engine (for use by SpeechRecognitionManager)
    var engine: AVAudioEngine? {
        return audioEngine
    }

    /// Check if engine is currently running
    var engineIsRunning: Bool {
        return audioEngine?.isRunning ?? false
    }

    // MARK: - Initialization

    init() {
        print("AudioEngineManager initialized")
        print("Fresh audio engine will be created for each recording session")
    }

    // MARK: - Public Methods

    /// Get a fresh audio engine instance for a new recording session
    func getFreshEngine() -> AVAudioEngine {
        // Stop and destroy any existing engine first
        if let existingEngine = audioEngine, existingEngine.isRunning {
            print("Stopping existing engine before creating fresh one")
            existingEngine.stop()
        }

        // Create fresh engine
        print("Creating fresh AVAudioEngine instance")
        let freshEngine = AVAudioEngine()
        audioEngine = freshEngine

        return freshEngine
    }

    /// Start the audio engine - creates a fresh engine for each session
    func startEngine() throws {
        print("Starting audio engine...")

        // Check if there's already a running engine
        if let engine = audioEngine, engine.isRunning {
            print("Audio engine already running")
            return
        }

        do {
            // CRITICAL: Create a FRESH engine for each recording session
            // This prevents autorelease pool corruption from reusing the same engine
            print("Creating fresh AVAudioEngine instance...")
            audioEngine = AVAudioEngine()

            guard let engine = audioEngine else {
                throw AudioEngineError.inputNodeUnavailable
            }

            // Prepare the engine
            engine.prepare()

            // Start the engine
            try engine.start()

            isRunning = true
            print("Audio engine started successfully (fresh instance)")
            printEngineConfiguration()

        } catch {
            print("Failed to start audio engine: \(error.localizedDescription)")
            currentError = error
            isRunning = false
            audioEngine = nil // Clean up on failure
            throw error
        }
    }

    /// Stop the audio engine and destroy the instance
    func stopEngine() {
        print("Stopping audio engine...")

        guard let engine = audioEngine else {
            print("No audio engine to stop")
            return
        }

        if !engine.isRunning {
            print("Audio engine already stopped")
            audioEngine = nil // Clean up even if already stopped
            isRunning = false
            return
        }

        engine.stop()
        isRunning = false

        // CRITICAL: Nil out the engine to release all resources
        // Next recording will get a completely fresh engine
        audioEngine = nil
        print("Audio engine stopped and destroyed")
    }

    /// Reset the audio engine (equivalent to stop with fresh engine approach)
    func resetEngine() {
        print("Resetting audio engine...")
        stopEngine()
        print("Audio engine reset completed (instance destroyed)")
    }

    /// Setup audio tap for recording (called by SpeechRecognitionManager)
    func setupAudioTap(bufferSize: AVAudioFrameCount = 1024,
                      format: AVAudioFormat? = nil,
                      tapBlock: @escaping AVAudioNodeTapBlock) {

        guard let engine = audioEngine else {
            print("ERROR: Cannot setup tap - no audio engine")
            return
        }

        let inputNode = engine.inputNode
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
        guard let engine = audioEngine else {
            print("No audio engine - tap already removed")
            return
        }
        engine.inputNode.removeTap(onBus: 0)
        print("Audio tap removed")
    }

    // MARK: - Private Methods

    /// Print current engine configuration for debugging
    private func printEngineConfiguration() {
        guard let engine = audioEngine else {
            print("=== Audio Engine Configuration ===")
            print("No engine instance")
            print("================================")
            return
        }

        let inputNode = engine.inputNode
        let outputFormat = inputNode.outputFormat(forBus: 0)

        print("=== Audio Engine Configuration ===")
        print("Running: \(engine.isRunning)")
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
        audioEngine = nil
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