# File-Based Recognition Implementation Plan

**Branch**: `file-based-recognition`
**Estimated Time**: 2-4 hours
**Status**: Ready to implement

## Overview

Migrate from `SFSpeechAudioBufferRecognitionRequest` (live streaming) to `SFSpeechURLRecognitionRequest` (file-based) to eliminate rapid start/stop cycle crashes.

## Approach

Record audio to temporary file → Transcribe file → Insert text → Delete file

## Architecture Changes

### 1. AudioEngineManager.swift

**Add file writing capability:**

```swift
private var audioFile: AVAudioFile?
private var recordingFileURL: URL?

func startRecording(to url: URL) throws {
    // Create audio file for writing
    let format = inputNode.outputFormat(forBus: 0)
    audioFile = try AVAudioFile(
        forWriting: url,
        settings: format.settings,
        commonFormat: .pcmFormatFloat32,
        interleaved: false
    )

    // Install tap that writes to file
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
        try? self?.audioFile?.write(from: buffer)
    }

    audioEngine.prepare()
    try audioEngine.start()

    recordingFileURL = url
}

func stopRecording() {
    inputNode.removeTap(onBus: 0)
    audioEngine.stop()
    audioFile = nil
}

func getRecordingURL() -> URL? {
    return recordingFileURL
}
```

### 2. SpeechRecognitionManager.swift

**Replace buffer recognition with file recognition:**

```swift
// REMOVE: SFSpeechAudioBufferRecognitionRequest
// REMOVE: recognitionRequest?.append(buffer)
// REMOVE: All buffer handling code

// ADD: File-based recognition
func transcribeFile(at url: URL) throws {
    logger.markEvent("FILE_TRANSCRIPTION_START")

    guard let recognizer = speechRecognizer, recognizer.isAvailable else {
        throw RecognitionError.recognizerNotAvailable
    }

    // Create file-based recognition request
    let request = SFSpeechURLRecognitionRequest(url: url)
    request.requiresOnDeviceRecognition = recognizer.supportsOnDeviceRecognition

    if #available(macOS 13.0, *) {
        request.addsPunctuation = true
    }

    // Start recognition task
    recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
        guard let self = self else { return }

        if let error = error {
            self.logger.logError(error, context: "File transcription error")
            self.currentError = error
            return
        }

        if let result = result {
            self.transcriptionText = result.bestTranscription.formattedString

            if result.isFinal {
                self.logger.markEvent("FILE_TRANSCRIPTION_COMPLETE")
                self.logger.log("Transcribed: \(self.transcriptionText)", level: .info)
                self.isRecognizing = false
            }
        }
    }
}

// Keep stopRecognition() mostly unchanged
// Just remove audio buffer handling
```

### 3. TempFileManager.swift (NEW)

**Create utility for managing temp audio files:**

```swift
import Foundation

class TempFileManager {
    static func createTempAudioFile() -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let filename = "dictation_\(UUID().uuidString).wav"
        return tempDir.appendingPathComponent(filename)
    }

    static func cleanup(_ url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
            DebugLogger.shared.log("Cleaned up temp file: \(url.lastPathComponent)", level: .debug)
        } catch {
            DebugLogger.shared.logError(error, context: "Failed to cleanup temp file")
        }
    }

    static func cleanupAllTempFiles() {
        let tempDir = FileManager.default.temporaryDirectory
        if let enumerator = FileManager.default.enumerator(at: tempDir, includingPropertiesForKeys: nil) {
            for case let fileURL as URL in enumerator {
                if fileURL.lastPathComponent.hasPrefix("dictation_") && fileURL.pathExtension == "wav" {
                    cleanup(fileURL)
                }
            }
        }
    }
}
```

### 4. AppDelegate.swift

**Update recording workflow:**

```swift
func startRecording() {
    // ... existing code ...

    // Create temp file for recording
    currentTempFile = TempFileManager.createTempAudioFile()

    do {
        try audioManager.startRecording(to: currentTempFile!)
        // ... rest of existing code ...
    } catch {
        logger.logError(error, context: "Failed to start recording")
        TempFileManager.cleanup(currentTempFile!)
        currentTempFile = nil
    }
}

func stopRecording() {
    // ... existing code ...

    // Stop audio recording
    audioManager.stopRecording()

    // Transcribe the recorded file
    if let tempFile = currentTempFile {
        do {
            try speechManager.transcribeFile(at: tempFile)

            // Wait for transcription to complete
            // (completion happens in recognitionTask callback)

        } catch {
            logger.logError(error, context: "Failed to transcribe file")
            updateMenuStatus("Transcription failed")
        }
    }

    // Note: Temp file cleanup happens after text insertion in the completion handler
}

// In the recognition task completion handler:
private func handleTranscriptionComplete() {
    let transcribedText = speechManager.transcriptionText

    // Clean transcription
    let cleanedText = transcriptionProcessor.cleanTranscription(transcribedText, removeFiller: true)

    // Insert text
    if !cleanedText.isEmpty {
        insertTranscribedText(cleanedText)
    }

    // Cleanup temp file
    if let tempFile = currentTempFile {
        TempFileManager.cleanup(tempFile)
        currentTempFile = nil
    }
}
```

## Implementation Checklist

### Phase 1: Core Changes (1-2 hours)
- [ ] Create `TempFileManager.swift`
- [ ] Modify `AudioEngineManager.swift` to write to file
- [ ] Replace buffer recognition with file recognition in `SpeechRecognitionManager.swift`
- [ ] Update `AppDelegate.swift` workflow
- [ ] Add cleanup on app quit

### Phase 2: Error Handling (30 min)
- [ ] Handle file creation failures
- [ ] Handle disk space issues
- [ ] Handle file write errors
- [ ] Add proper error messages to user

### Phase 3: Testing (1 hour)
- [ ] Test basic recording and transcription
- [ ] Test rapid start/stop cycles (should NOT crash)
- [ ] Test with different recording lengths
- [ ] Test temp file cleanup
- [ ] Measure latency difference vs streaming

### Phase 4: Optimization (30 min)
- [ ] Benchmark file I/O overhead
- [ ] Consider using in-memory buffer if faster
- [ ] Add progress indicator during transcription
- [ ] Clean up old temp files on app launch

## Expected Improvements

✅ **No more crashes** - Eliminates rapid start/stop cycle issue
✅ **Stable** - File-based API is widely used and proven
✅ **Minimal changes** - Same framework, just different request type
✅ **Same quality** - Same recognition engine

## Potential Drawbacks

⚠️ **Latency increase**: ~50-200ms added for file I/O
⚠️ **Disk writes**: Temporary disk usage (cleaned up immediately)
⚠️ **Not real-time**: User sees text AFTER speaking completes

## Testing Metrics

After implementation, measure:
- [ ] Crash rate (should be 0%)
- [ ] Latency (recording stop → text appears)
- [ ] Disk I/O overhead
- [ ] User experience (does latency feel noticeable?)

## Rollback Plan

If this approach has issues:
1. This branch preserves the change history
2. Can easily revert by checking out previous commit
3. Master branch still has working baseline
4. WhisperKit branch available as alternative

## Next Steps After Success

If file-based approach works:
1. Merge to master
2. Deploy for testing
3. Collect user feedback
4. Compare with WhisperKit implementation
5. Choose best approach for production

---

**Ready to implement**: All design decisions made, implementation path clear.
