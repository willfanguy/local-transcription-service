# Alternative Transcription Approaches

**Date**: November 8, 2025
**Context**: After extensive debugging, discovered Apple's `SFSpeechAudioBufferRecognitionRequest` (live streaming) has critical autorelease pool bugs during rapid start/stop cycles.

## The Core Problem

Apple's Speech framework creates autoreleased objects during recognition callbacks that persist beyond the recognizer's lifecycle. When doing rapid start/stop cycles (< 5 seconds between sessions), the main event loop's autorelease pool tries to release objects referencing deallocated memory → `EXC_BAD_ACCESS` crash.

**This is a framework bug, not our code.**

## Key Finding: Industry Standard is "Record-Then-Transcribe"

After researching Vocorize, Open-Whispr, and other successful dictation apps, **none use live streaming**. All use:

1. Press hotkey → Record audio to buffer/file
2. Release hotkey → Stop recording
3. Transcribe complete audio (one-shot, no cycling)
4. Insert text

This eliminates rapid cycling entirely.

---

## Option 1: Apple File-Based Recognition (Easiest Migration)

### Overview

Apple's Speech framework has a **file-based API** we're not using: `SFSpeechURLRecognitionRequest`

### How It Works

```swift
// Record audio to temp file with AVAudioEngine
let audioFile = try AVAudioFile(
    forWriting: tempURL,
    settings: recordingFormat.settings,
    commonFormat: .pcmFormatFloat32,
    interleaved: false
)

// While user holds key, write buffers to file
inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
    try? audioFile.write(from: buffer)
}

// When user releases, transcribe the file
let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
let request = SFSpeechURLRecognitionRequest(url: tempURL)
request.requiresOnDeviceRecognition = true
request.addsPunctuation = true

recognizer.recognitionTask(with: request) { result, error in
    if let transcription = result?.bestTranscription.formattedString {
        // Insert text
    }
}

// Delete temp file
try? FileManager.default.removeItem(at: tempURL)
```

### Pros

✅ **Minimal code changes** - Same Speech framework, different request type
✅ **Eliminates rapid cycling** - One recognition task per recording session
✅ **Same privacy** - On-device recognition still available
✅ **Same quality** - Same underlying recognition engine
✅ **Native integration** - No new dependencies
✅ **Proven stable** - File-based API widely used for transcription apps

### Cons

❌ **Not truly real-time** - User sees text AFTER speaking (but still fast, ~1s latency)
❌ **Disk I/O overhead** - Writing/reading temp files adds ~50-100ms
⚠️ **Still 1-minute limit** - But per file, so not an issue for typical use

### Implementation Effort

**~2-4 hours** - Straightforward changes to existing codebase

**Files to modify:**
- `AudioEngineManager.swift` - Add file writing capability
- `SpeechRecognitionManager.swift` - Replace buffer request with URL request
- `AppDelegate.swift` - No changes needed (same start/stop flow)

### Code Changes Summary

1. In `AudioEngineManager`:
   ```swift
   private var audioFile: AVAudioFile?

   func startRecording(to url: URL) {
       audioFile = try AVAudioFile(forWriting: url, ...)
       inputNode.installTap(...) { buffer, _ in
           try? self.audioFile?.write(from: buffer)
       }
   }
   ```

2. In `SpeechRecognitionManager`:
   ```swift
   func transcribeFile(at url: URL) {
       let request = SFSpeechURLRecognitionRequest(url: url)
       request.requiresOnDeviceRecognition = recognizer.supportsOnDeviceRecognition
       request.addsPunctuation = true

       recognitionTask = recognizer.recognitionTask(with: request) { result, error in
           // Handle result
       }
   }
   ```

### Testing Strategy

- Test rapid press/release cycles (stress test)
- Test with different recording lengths
- Verify temp file cleanup
- Measure latency (recording stop → text available)
- Test across different apps for text insertion

---

## Option 2: WhisperKit (Modern Swift/CoreML Solution)

### Overview

**WhisperKit** is Argmax's Swift-native, Apple Silicon-optimized implementation of OpenAI's Whisper model, converted to CoreML format for on-device inference.

**GitHub**: https://github.com/argmaxinc/WhisperKit
**Used by**: Vocorize (open source dictation app)

### How It Works

```swift
// One-time setup
let whisperKit = try await WhisperKit(
    model: "tiny",  // or base, small, medium, large-v3
    computeOptions: .init(
        audioEncoderCompute: .cpuAndNeuralEngine,
        textDecoderCompute: .cpuAndNeuralEngine
    )
)

// Transcribe audio file
let result = try await whisperKit.transcribe(audioPath: tempURL.path)
let text = result?.text ?? ""

// Or streaming (real-time)
for try await result in whisperKit.transcribeStream(audioPath: tempURL.path) {
    // Update UI with partial results
}
```

### Key Features

- **Real-time streaming** - Can show partial results during transcription
- **Voice Activity Detection (VAD)** - Built-in silence detection
- **Word timestamps** - Know exactly when each word was spoken
- **Multiple model sizes** - Trade speed for accuracy
  - `tiny` (~75MB) - Fastest, good for short phrases
  - `base` (~145MB) - Balanced
  - `small` (~488MB) - Better accuracy
  - `medium` (~1.5GB) - High accuracy
  - `large-v3` (~3GB) - Best quality
- **Metal GPU acceleration** - Optimized for Apple Silicon
- **On-device only** - No cloud dependencies
- **Swift Package Manager** - Easy integration

### Pros

✅ **No Apple framework bugs** - Completely independent implementation
✅ **Real streaming support** - True real-time if desired
✅ **Better accuracy** - Whisper often beats Apple's recognizer
✅ **More languages** - 99 languages vs Apple's ~50
✅ **Full control** - Can customize transcription pipeline
✅ **Active development** - Argmax maintains it professionally
✅ **Production-ready** - Used by commercial apps
✅ **Word timestamps** - Enable advanced features

### Cons

❌ **New dependency** - Adds Swift package
❌ **Model download** - Requires downloading 75MB-3GB model on first use
❌ **Higher latency** - ~0.5-1s vs Apple's ~0.1-0.3s for streaming
❌ **Learning curve** - New API to learn
❌ **macOS 14.0+** - Requires newer OS
⚠️ **Disk space** - Models take space

### Installation

**Swift Package Manager:**
```swift
dependencies: [
    .package(url: "https://github.com/argmaxinc/WhisperKit", from: "0.7.0")
]
```

**Or Homebrew (CLI tool):**
```bash
brew install whisperkit-cli
```

### Implementation Effort

**~1-2 days** - New framework to integrate, but clean separation

**Files to modify:**
- Create new `WhisperKitManager.swift` - Wrapper around WhisperKit
- `AudioEngineManager.swift` - Record to file (same as Option 1)
- `SpeechRecognitionManager.swift` - Replace with WhisperKitManager
- `AppDelegate.swift` - Minimal changes to initialization

### Code Structure

```swift
// New file: WhisperKitManager.swift
class WhisperKitManager: ObservableObject {
    private var whisperKit: WhisperKit?

    @Published var transcriptionText: String = ""
    @Published var isTranscribing: Bool = false

    func initialize(model: String = "base") async throws {
        whisperKit = try await WhisperKit(model: model)
    }

    func transcribe(audioFile: URL) async throws -> String {
        guard let result = try await whisperKit?.transcribe(audioPath: audioFile.path) else {
            throw TranscriptionError.failed
        }
        return result.text
    }

    func transcribeStreaming(audioFile: URL) async throws {
        guard let whisperKit = whisperKit else { return }

        for try await result in whisperKit.transcribeStream(audioPath: audioFile.path) {
            await MainActor.run {
                self.transcriptionText = result.text
            }
        }
    }
}
```

### Model Selection Strategy

| Model | Size | Speed | Use Case |
|-------|------|-------|----------|
| `tiny` | 75MB | Fastest (~0.3s) | Quick phrases, commands |
| `base` | 145MB | Fast (~0.5s) | General dictation (recommended) |
| `small` | 488MB | Medium (~1s) | Longer content, better accuracy |
| `medium` | 1.5GB | Slow (~3s) | Transcription tasks, not real-time |
| `large-v3` | 3GB | Very slow (~5s+) | Offline transcription only |

**Recommendation**: Start with `base` model - best speed/accuracy trade-off for dictation.

### Testing Strategy

- Download and test with `tiny` model first (fastest iteration)
- Benchmark latency with different model sizes
- Test accuracy compared to Apple's framework
- Test resource usage (CPU, memory, battery)
- Verify model switching works smoothly

### Migration Path

1. **Phase 1**: Implement alongside existing Speech framework
2. **Phase 2**: Add settings toggle to switch between engines
3. **Phase 3**: Collect feedback on accuracy/speed
4. **Phase 4**: Make default if superior

---

## Option 3: Whisper.cpp (For Maximum Performance)

### Overview

**Whisper.cpp-Realtime-Mac-Os** is a macOS-optimized fork of whisper.cpp with ~85% smaller codebase and Metal GPU acceleration.

**GitHub**: https://github.com/tristan-mcinnis/Whisper.cpp-Realtime-Mac-Os

### Performance

- **Exceptionally fast**: <0.5s to process 5 seconds of speech
- Metal acceleration for Apple Silicon
- VAD with adjustable sensitivity
- SDL2 for audio capture

### Pros

✅ **Fastest option** - Highly optimized C++
✅ **Low latency** - Sub-500ms for typical phrases
✅ **Metal acceleration** - GPU-optimized
✅ **Lightweight** - Minimal overhead

### Cons

❌ **CLI tool only** - No library API provided
❌ **C++ → Swift bridge** - Complex integration
❌ **High maintenance** - C++ FFI is fragile
❌ **Not recommended** - Integration effort not worth it

### Verdict

**Not recommended** unless we need absolute maximum performance. The CLI-only nature makes integration very difficult.

---

## Option 4: OpenAI Whisper API (Cloud-Based)

### Overview

Use OpenAI's hosted Whisper API for transcription (requires API key).

### Pros

✅ **No local models** - No disk space needed
✅ **Always latest** - Automatic updates
✅ **Highest accuracy** - Full-size models

### Cons

❌ **Privacy concerns** - Audio sent to cloud
❌ **Requires internet** - No offline support
❌ **API costs** - $0.006/minute (not expensive, but costs)
❌ **Latency** - Network round-trip adds delay
❌ **Against project goals** - We want local/private

### Verdict

**Not recommended** - Goes against the "local dictation" goal.

---

## Comparison Matrix

| Approach | Integration | Latency | Stability | Privacy | Accuracy | Cost |
|----------|------------|---------|-----------|---------|----------|------|
| **Apple File-Based** | ⭐️ Easy (2-4h) | ~1s | ⭐️⭐️⭐️ High | ⭐️⭐️⭐️ Local | ⭐️⭐️ Good | Free |
| **WhisperKit** | ⭐️⭐️ Medium (1-2d) | ~0.5-1s | ⭐️⭐️⭐️ High | ⭐️⭐️⭐️ Local | ⭐️⭐️⭐️ Excellent | Free |
| **Whisper.cpp** | ⭐️⭐️⭐️ Hard (1w) | ~0.3s | ⭐️⭐️ Medium | ⭐️⭐️⭐️ Local | ⭐️⭐️⭐️ Excellent | Free |
| **OpenAI API** | ⭐️ Easy (4h) | ~2s | ⭐️⭐️⭐️ High | ❌ Cloud | ⭐️⭐️⭐️ Best | $0.006/min |
| **Current (Streaming)** | ✅ Done | ~0.1s | ❌ Crashes | ⭐️⭐️⭐️ Local | ⭐️⭐️ Good | Free |

---

## Recommendations

### Immediate (This Week)

**Implement Option 1: Apple File-Based API**

**Why:**
- Quickest path to stability (2-4 hours)
- Minimal risk - same framework, different API
- Eliminates the rapid cycling crash
- Keeps all existing features

**If it still has issues** → Pivot to WhisperKit

### Future Enhancement (Next Sprint)

**Add Option 2: WhisperKit as Alternative Engine**

**Why:**
- Better accuracy than Apple's framework
- More languages supported
- Full control over pipeline
- Production-ready (Vocorize uses it)

**Implementation:**
- Keep Apple file-based as fallback
- Add settings toggle for engine selection
- Let users choose speed vs accuracy
- Collect feedback on which is better

### Not Recommended

- ❌ **Whisper.cpp** - Integration too complex for benefit
- ❌ **OpenAI API** - Against project privacy goals
- ❌ **Fix Apple streaming** - It's a framework bug we can't fix

---

## Migration Strategy

### Phase 1: Stabilize (This Week)
1. Implement Apple file-based recognition
2. Remove all recognizer reset logic
3. Test rapid cycling for stability
4. Measure latency impact
5. Deploy for testing

### Phase 2: Enhance (Next 1-2 Weeks)
1. Integrate WhisperKit SDK
2. Download `base` model
3. Add engine selection in settings
4. Benchmark both engines
5. Default to better one

### Phase 3: Polish (Future)
1. Add model size selection for WhisperKit
2. Implement streaming UI updates (if using WhisperKit)
3. Add accuracy comparison mode
4. Optimize for M1/M2/M3 specifically
5. Consider Argmax Pro SDK if needed

---

## Technical Details

### Apple File-Based: Temp File Management

```swift
class TempFileManager {
    static func createTempAudioFile() -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let filename = "dictation_\(UUID().uuidString).wav"
        return tempDir.appendingPathComponent(filename)
    }

    static func cleanup(_ url: URL) {
        try? FileManager.default.removeItem(at: url)
    }
}

// Usage
let tempFile = TempFileManager.createTempAudioFile()
// ... record audio ...
// ... transcribe ...
TempFileManager.cleanup(tempFile)
```

### WhisperKit: Model Download Strategy

```swift
// Check if model exists locally
let modelExists = await whisperKit.modelExists("base")

if !modelExists {
    // Show download progress
    let progress = await whisperKit.downloadModel("base") { progress in
        // Update UI: "Downloading model: \(progress * 100)%"
    }
}

// Model is now available for transcription
```

### Performance Monitoring

```swift
func measureTranscriptionLatency(audioFile: URL) async {
    let start = Date()

    let transcription = try await transcribe(audioFile)

    let latency = Date().timeIntervalSince(start)
    print("Transcription latency: \(latency)s")

    // Log to analytics
    analytics.log("transcription_latency", value: latency)
}
```

---

## Resources

### Documentation
- [Apple Speech Framework](https://developer.apple.com/documentation/speech)
- [WhisperKit GitHub](https://github.com/argmaxinc/WhisperKit)
- [WhisperKit Docs](https://github.com/argmaxinc/WhisperKit/wiki)
- [Whisper.cpp](https://github.com/ggml-org/whisper.cpp)

### Open Source Examples
- [Vocorize](https://github.com/vocorize/app) - WhisperKit implementation
- [Open-Whispr](https://github.com/HeroTools/open-whispr) - Electron + Whisper
- [whisper-dictation](https://github.com/foges/whisper-dictation) - Python + Whisper

### Research
- [Whisper Paper (OpenAI)](https://cdn.openai.com/papers/whisper.pdf)
- [CoreML Optimization](https://developer.apple.com/documentation/coreml)
- [Metal Performance Shaders](https://developer.apple.com/documentation/metalperformanceshaders)

---

**Last Updated**: November 8, 2025
**Status**: Ready for implementation
**Recommended Next Step**: Implement Apple File-Based API (Option 1)
