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

    /// Flag to prevent concurrent stop operations
    private var isStopping: Bool = false

    /// Flag to indicate cleanup is in progress (including async tap removal)
    @Published var isCleaningUp: Bool = false

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
    func setAudioEngine(_ engine: AVAudioEngine?) {
        self.audioEngine = engine
        if engine != nil {
            print("Audio engine set for speech recognition")
        } else {
            print("Audio engine cleared")
        }
    }

    /// Set the recognition language
    func setLanguage(_ languageCode: String) {
        // Stop any active recognition
        stopRecognition()

        // Create new recognizer with the specified language
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
        speechRecognizer?.delegate = self

        // Log new configuration
        if let recognizer = speechRecognizer {
            print("=== Speech Recognizer Language Changed ===")
            print("New locale: \(recognizer.locale)")
            print("Available: \(recognizer.isAvailable)")
            print("Supports on-device recognition: \(recognizer.supportsOnDeviceRecognition)")
        } else {
            print("ERROR: Failed to create speech recognizer for language: \(languageCode)")
        }
    }

    /// Start speech recognition - MUST be called on main thread
    func startRecognition() throws {
        // Enforce main thread
        dispatchPrecondition(condition: .onQueue(.main))

        print("Starting speech recognition...")

        // Don't start if cleanup in progress or already recording
        guard !isCleaningUp && !isRecognizing else {
            print("⚠️ Cannot start: cleanup in progress or already recording")
            throw RecognitionError.failedToCreateRequest
        }

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

        // Perform start
        try performStartRecognition(audioEngine: audioEngine, recognizer: recognizer)
    }

    private func performStartRecognition(audioEngine: AVAudioEngine, recognizer: SFSpeechRecognizer) throws {
        // Ensure any old objects are cleaned up before creating new ones
        if recognitionRequest != nil || recognitionTask != nil {
            print("⚠️ Warning: Old recognition objects still exist, cleaning up first")

            // Cancel old task if it exists
            recognitionTask?.cancel()

            // Clear references
            recognitionRequest = nil
            recognitionTask = nil

            print("Old objects cleared")
        }

        // Create recognition request
        try createAndStartRecognition(audioEngine: audioEngine, recognizer: recognizer)
    }

    private func createAndStartRecognition(audioEngine: AVAudioEngine, recognizer: SFSpeechRecognizer) throws {
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

        // Enable automatic punctuation
        if #available(macOS 13.0, *) {
            recognitionRequest.addsPunctuation = true
            print("Automatic punctuation enabled")
        }

        // Get input node
        let inputNode = audioEngine.inputNode

        // Get recording format
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        print("Recording format: \(recordingFormat)")

        // Note: No need to remove tap here - reset() in stopRecognition() already cleared it

        // Install tap with buffer size 1024
        // Use weak reference to prevent retain cycles and safely handle cleanup
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            // Check if request still exists before appending (prevents crash during cleanup)
            guard let self = self, let request = self.recognitionRequest else {
                return
            }
            request.append(buffer)
        }
        print("Audio tap installed")

        // Prepare and start audio engine
        audioEngine.prepare()
        try audioEngine.start()
        print("Audio engine started")

        // Create recognition task
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            // CRITICAL: Wrap entire handler in autoreleasepool to immediately drain
            // any autoreleased objects created by Speech framework
            autoreleasepool {
                guard let self = self else { return }

                // CRITICAL: Check if this task was cancelled (old task from previous recording)
                // If cancelled, don't update state to avoid interfering with new recording
                if error != nil {
                    let nsError = error! as NSError
                    if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 216 {
                        print("⚠️ Completion handler from cancelled task ignored")
                        return
                    }
                }

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
                    }
                }

                // Don't call stopRecognition() here - let the caller handle stopping
                // This prevents race conditions with manual stops
                if error != nil || isFinal {
                    print("Recognition task completed (final: \(isFinal), error: \(error != nil))")
                    // Just mark as not recognizing, don't do full cleanup
                    DispatchQueue.main.async {
                        self.isRecognizing = false
                    }
                }
            }
        }

        isRecognizing = true
        print("Recognition started successfully")
    }

    /// Stop speech recognition
    func stopRecognition(completion: (() -> Void)? = nil) {
        // Prevent concurrent stop operations
        guard !isStopping else {
            print("Stop already in progress, skipping")
            completion?()
            return
        }

        // Check if there's anything to stop
        guard isRecognizing || recognitionTask != nil || (audioEngine?.isRunning ?? false) else {
            print("Nothing to stop, recognition already inactive")
            completion?()
            return
        }

        isStopping = true
        isCleaningUp = true
        print("Stopping speech recognition...")

        // 1. Stop audio engine
        if let audioEngine = audioEngine, audioEngine.isRunning {
            audioEngine.stop()
            print("Audio engine stopped")
        }

        // 2. Stop recognition request
        if let request = recognitionRequest {
            request.endAudio()
            recognitionRequest = nil
            print("Recognition request ended")
        }

        // 3. Cancel recognition task
        if let task = recognitionTask {
            task.cancel()
            recognitionTask = nil
            print("Recognition task cancelled")
        }

        // 4. Remove tap (engine is stopped, so this is safe)
        if let audioEngine = audioEngine, audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
            print("Audio tap removed")
        }

        // 5. Update state
        isRecognizing = false
        isStopping = false
        isCleaningUp = false
        print("Recognition stopped")

        // 6. Notify completion
        completion?()
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