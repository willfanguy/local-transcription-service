//
//  SpeechRecognitionManager.swift
//  LocalDictation
//
//  Manages speech recognition using SFSpeechRecognizer
//

import Foundation
import Speech
import AVFoundation

/// Manages speech recognition and transcription
class SpeechRecognitionManager: NSObject, ObservableObject {

    // MARK: - Properties

    /// The speech recognizer for US English
    private var speechRecognizer: SFSpeechRecognizer?

    /// The current recognition request
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    /// The current recognition task
    private var recognitionTask: SFSpeechRecognitionTask?

    /// The audio engine (will be provided by AudioEngineManager)
    private var audioEngine: AVAudioEngine?

    // MARK: - Published Properties

    /// Current transcription text
    @Published var transcriptionText: String = ""

    /// Whether recognition is currently active
    @Published var isRecognizing: Bool = false

    /// Current error if any
    @Published var currentError: Error?

    // MARK: - Initialization

    override init() {
        super.init()
        setupSpeechRecognizer()
    }

    // MARK: - Setup

    /// Initialize the speech recognizer
    private func setupSpeechRecognizer() {
        // Create recognizer for US English
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

        // Set delegate
        speechRecognizer?.delegate = self

        // Check availability
        if let recognizer = speechRecognizer {
            print("=== Speech Recognizer Status ===")
            print("Available: \(recognizer.isAvailable)")
            print("Locale: \(recognizer.locale)")
            print("Supports on-device recognition: \(recognizer.supportsOnDeviceRecognition)")

            // Prefer on-device recognition for privacy
            if recognizer.supportsOnDeviceRecognition {
                print("Using on-device recognition for privacy")
            }
        } else {
            print("ERROR: Failed to create speech recognizer")
        }
    }

    // MARK: - Public Methods

    /// Set the audio engine to use (provided by AudioEngineManager)
    func setAudioEngine(_ engine: AVAudioEngine) {
        self.audioEngine = engine
        print("Audio engine set for speech recognition")
    }

    /// Start speech recognition
    func startRecognition() throws {
        print("Starting speech recognition...")

        // Check if recognizer is available
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            let error = RecognitionError.recognizerNotAvailable
            currentError = error
            throw error
        }

        // Check audio engine
        guard let audioEngine = audioEngine else {
            let error = RecognitionError.audioEngineNotSet
            currentError = error
            throw error
        }

        // Cancel any existing task
        stopRecognition()

        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            let error = RecognitionError.failedToCreateRequest
            currentError = error
            throw error
        }

        // Configure request
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = recognizer.supportsOnDeviceRecognition

        // Get input node
        let inputNode = audioEngine.inputNode

        // Remove any existing tap
        inputNode.removeTap(onBus: 0)

        // Get recording format
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        // Install tap with buffer size 1024
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        // Start audio engine
        audioEngine.prepare()
        try audioEngine.start()

        // Create recognition task
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            var isFinal = false

            if let result = result {
                // Update transcription
                self.transcriptionText = result.bestTranscription.formattedString
                isFinal = result.isFinal

                print("Transcribed: \(self.transcriptionText)")

                if isFinal {
                    print("Recognition final result received")
                }
            }

            if let error = error {
                print("Recognition error: \(error.localizedDescription)")
                self.currentError = error

                // Check for 1-minute timeout
                if (error as NSError).code == 203 {
                    print("Recognition timeout (1-minute limit reached)")
                    // Could implement restart logic here
                }
            }

            if error != nil || isFinal {
                self.stopRecognition()
            }
        }

        isRecognizing = true
        print("Recognition started successfully")
    }

    /// Stop speech recognition
    func stopRecognition() {
        print("Stopping speech recognition...")

        // Stop the recognition task
        recognitionTask?.cancel()
        recognitionTask = nil

        // Stop the recognition request
        recognitionRequest?.endAudio()
        recognitionRequest = nil

        // Stop audio engine
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        isRecognizing = false
        print("Recognition stopped")
    }

    /// Test recognition for specified duration
    func testRecognition(duration: TimeInterval) {
        print("Starting \(duration) second test recording...")

        do {
            try startRecognition()

            // Stop after specified duration
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.stopRecognition()
                print("Test recording completed")
                print("Final transcription: \(self?.transcriptionText ?? "No text")")
            }
        } catch {
            print("Test recording failed: \(error.localizedDescription)")
            currentError = error
        }
    }

    // MARK: - Cleanup

    deinit {
        stopRecognition()
    }
}

// MARK: - SFSpeechRecognizerDelegate

extension SpeechRecognitionManager: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("Speech recognizer availability changed: \(available)")

        if !available {
            stopRecognition()
            currentError = RecognitionError.recognizerNotAvailable
        }
    }
}

// MARK: - Recognition Errors

enum RecognitionError: LocalizedError {
    case recognizerNotAvailable
    case audioEngineNotSet
    case failedToCreateRequest
    case microphonePermissionDenied
    case speechPermissionDenied
    case recognitionTimeout

    var errorDescription: String? {
        switch self {
        case .recognizerNotAvailable:
            return "Speech recognizer is not available"
        case .audioEngineNotSet:
            return "Audio engine not configured"
        case .failedToCreateRequest:
            return "Failed to create recognition request"
        case .microphonePermissionDenied:
            return "Microphone permission denied"
        case .speechPermissionDenied:
            return "Speech recognition permission denied"
        case .recognitionTimeout:
            return "Recognition timeout (1-minute limit)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .recognizerNotAvailable:
            return "Check internet connection or language settings"
        case .audioEngineNotSet:
            return "Internal configuration error"
        case .failedToCreateRequest:
            return "Try restarting the app"
        case .microphonePermissionDenied, .speechPermissionDenied:
            return "Grant permissions in System Settings"
        case .recognitionTimeout:
            return "Recording automatically stopped after 1 minute"
        }
    }
}