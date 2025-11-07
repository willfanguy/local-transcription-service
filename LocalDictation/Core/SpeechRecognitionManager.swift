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

    /// Track timing for debugging
    private var recognitionStartTime: Date?
    private var lastPartialResultTime: Date?

    /// Debug logger instance
    private let logger = DebugLogger.shared

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
        logger.logLifecycle(self, event: .initialized, additionalInfo: "SpeechRecognitionManager created")
        logger.markEvent("SPEECH_RECOGNITION_MANAGER_INIT")
        setupSpeechRecognizer()
    }

    // MARK: - Setup

    /// Initialize the speech recognizer
    private func setupSpeechRecognizer() {
        logger.logMethodEntry("setupSpeechRecognizer", parameters: "locale: en-US")

        // Create recognizer for US English
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

        // Set delegate
        speechRecognizer?.delegate = self

        // Check availability
        if let recognizer = speechRecognizer {
            logger.logLifecycle(recognizer, event: .initialized, additionalInfo: "locale: \(recognizer.locale)")
            logger.log("=== Speech Recognizer Status ===", level: .info)
            logger.log("Available: \(recognizer.isAvailable)", level: .info)
            logger.log("Locale: \(recognizer.locale)", level: .info)
            logger.log("Supports on-device recognition: \(recognizer.supportsOnDeviceRecognition)", level: .info)

            // Prefer on-device recognition for privacy
            if recognizer.supportsOnDeviceRecognition {
                logger.log("Using on-device recognition for privacy", level: .info)
            }
        } else {
            logger.log("ERROR: Failed to create speech recognizer", level: .error)
        }

        logger.logMethodExit("setupSpeechRecognizer")
    }

    // MARK: - Public Methods

    /// Set the audio engine to use (provided by AudioEngineManager)
    func setAudioEngine(_ engine: AVAudioEngine) {
        self.audioEngine = engine
        print("Audio engine set for speech recognition")
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

    /// Start speech recognition
    func startRecognition() throws {
        logger.markEvent("START_RECOGNITION_ATTEMPT")
        logger.logMethodEntry("startRecognition")
        logger.log("Thread: \(Thread.isMainThread ? "Main" : "Background-\(Thread.current)")", level: .debug)

        recognitionStartTime = Date()

        // Check if recognizer is available
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            let error = RecognitionError.recognizerNotAvailable
            logger.logError(error, context: "Recognizer not available")
            currentError = error
            throw error
        }

        logger.log("Recognizer available, memory address: \(Unmanaged.passUnretained(recognizer).toOpaque())", level: .debug)

        // Check audio engine
        guard let audioEngine = audioEngine else {
            let error = RecognitionError.audioEngineNotSet
            logger.logError(error, context: "Audio engine not set")
            currentError = error
            throw error
        }

        logger.log("Audio engine available, running: \(audioEngine.isRunning)", level: .debug)

        // Cancel any existing task
        if recognitionTask != nil {
            logger.log("Existing recognition task found, stopping it first", level: .warning)
        }
        stopRecognition()

        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            let error = RecognitionError.failedToCreateRequest
            logger.logError(error, context: "Failed to create recognition request")
            currentError = error
            throw error
        }

        logger.logLifecycle(recognitionRequest, event: .initialized, additionalInfo: "Recognition request created")

        // Configure request
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = recognizer.supportsOnDeviceRecognition

        // Enable automatic punctuation
        if #available(macOS 13.0, *) {
            recognitionRequest.addsPunctuation = true
            logger.log("Automatic punctuation enabled", level: .debug)
        }

        // Get input node
        let inputNode = audioEngine.inputNode
        logger.log("Input node bus count: \(inputNode.numberOfInputs)", level: .debug)

        // Remove any existing tap - with error handling
        logger.log("Attempting to remove existing tap on bus 0", level: .debug)
        do {
            inputNode.removeTap(onBus: 0)
            logger.log("Successfully removed tap (or no tap existed)", level: .debug)
        } catch {
            logger.logError(error, context: "Failed to remove tap - this might be normal if no tap exists")
        }

        // Get recording format
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        logger.log("Recording format: \(recordingFormat)", level: .debug)

        // Install tap with buffer size 1024
        logger.log("Installing tap on bus 0 with buffer size 1024", level: .debug)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        logger.log("Tap installed successfully", level: .debug)

        // Start audio engine
        logger.log("Preparing audio engine", level: .debug)
        audioEngine.prepare()

        logger.log("Starting audio engine", level: .debug)
        try audioEngine.start()
        logger.log("Audio engine started, running: \(audioEngine.isRunning)", level: .info)

        // Create recognition task
        logger.log("Creating recognition task", level: .debug)
        let taskCreationTime = Date()

        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else {
                DebugLogger.shared.log("Completion handler called but self is nil", level: .warning)
                return
            }

            let handlerTime = Date()
            let timeSinceStart = self.recognitionStartTime.map { handlerTime.timeIntervalSince($0) } ?? 0
            self.logger.log("Completion handler called, time since start: \(timeSinceStart)s, thread: \(Thread.isMainThread ? "Main" : "Background")", level: .debug)

            var isFinal = false

            if let result = result {
                // Update transcription
                self.transcriptionText = result.bestTranscription.formattedString
                isFinal = result.isFinal

                let now = Date()
                if let lastTime = self.lastPartialResultTime {
                    self.logger.log("Time between results: \(now.timeIntervalSince(lastTime) * 1000)ms", level: .trace)
                }
                self.lastPartialResultTime = now

                self.logger.log("Transcribed (\(isFinal ? "FINAL" : "partial")): \(self.transcriptionText)", level: .info)

                if isFinal {
                    self.logger.markEvent("RECOGNITION_FINAL_RESULT")
                    if let startTime = self.recognitionStartTime {
                        self.logger.logTiming("Total recognition", start: startTime)
                    }
                }
            }

            if let error = error {
                self.logger.logError(error, context: "Recognition task error")
                self.currentError = error

                // Check for 1-minute timeout
                let nsError = error as NSError
                self.logger.log("Error domain: \(nsError.domain), code: \(nsError.code)", level: .error)

                if nsError.code == 203 {
                    self.logger.markEvent("RECOGNITION_TIMEOUT_1_MINUTE")
                    // Could implement restart logic here
                }
            }

            if error != nil || isFinal {
                self.logger.log("Stopping recognition due to: \(error != nil ? "error" : "final result")", level: .info)
                self.stopRecognition()
            }
        }

        if let task = recognitionTask {
            logger.logLifecycle(task, event: .initialized, additionalInfo: "Recognition task created")
            logger.log("Task state after creation: \(task.state.rawValue)", level: .debug)
        }

        logger.logTiming("Task creation", start: taskCreationTime)

        isRecognizing = true
        logger.markEvent("RECOGNITION_STARTED_SUCCESSFULLY")
        logger.logMethodExit("startRecognition", result: "success")
    }

    /// Stop speech recognition
    func stopRecognition() {
        logger.markEvent("STOP_RECOGNITION_CALLED")
        logger.logMethodEntry("stopRecognition")
        logger.log("Thread: \(Thread.isMainThread ? "Main" : "Background-\(Thread.current)")", level: .debug)

        let stopStartTime = Date()

        // Log current state
        logger.log("Current state - task: \(recognitionTask != nil), request: \(recognitionRequest != nil), engine running: \(audioEngine?.isRunning ?? false)", level: .debug)

        // Wrap cleanup in autoreleasepool to force immediate release
        autoreleasepool {
            // Stop the recognition task
            if let task = recognitionTask {
                logger.log("Cancelling recognition task, current state: \(task.state.rawValue)", level: .debug)
                logger.logLifecycle(task, event: .released, additionalInfo: "About to cancel")
                task.cancel()
                logger.log("Recognition task cancelled", level: .debug)
                recognitionTask = nil
            } else {
                logger.log("No recognition task to cancel", level: .debug)
            }

            // Stop the recognition request
            if let request = recognitionRequest {
                logger.log("Ending audio on recognition request", level: .debug)
                logger.logLifecycle(request, event: .released, additionalInfo: "About to end audio")
                request.endAudio()
                logger.log("Recognition request audio ended", level: .debug)
                recognitionRequest = nil
            } else {
                logger.log("No recognition request to end", level: .debug)
            }
        }

        // Stop audio engine
        if let audioEngine = audioEngine {
            logger.log("Stopping audio engine, currently running: \(audioEngine.isRunning)", level: .debug)

            if audioEngine.isRunning {
                audioEngine.stop()
                logger.log("Audio engine stopped", level: .debug)
            }

            // Remove tap with error handling
            logger.log("Removing tap from input node", level: .debug)
            do {
                audioEngine.inputNode.removeTap(onBus: 0)
                logger.log("Tap removed successfully", level: .debug)
            } catch {
                logger.logError(error, context: "Error removing tap - this may be expected if no tap exists")
            }
        } else {
            logger.log("No audio engine to stop", level: .debug)
        }

        isRecognizing = false

        // Clear timing variables
        recognitionStartTime = nil
        lastPartialResultTime = nil

        logger.logTiming("Stop recognition", start: stopStartTime)
        logger.markEvent("RECOGNITION_STOPPED")
        logger.logMethodExit("stopRecognition")
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
        logger.markEvent("SPEECH_RECOGNITION_MANAGER_DEINIT")
        logger.logLifecycle(self, event: .deinitialized, additionalInfo: "SpeechRecognitionManager being deallocated")
        stopRecognition()
        logger.log("SpeechRecognitionManager cleanup complete", level: .info)
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