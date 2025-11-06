# Local Dictation App Development Plan

## Project Overview

Build a macOS menu bar application that provides system-wide voice dictation using Apple's native Speech framework. The app will allow users to trigger dictation via a global hotkey, transcribe speech in real-time, and insert the transcribed text into any active application.

## Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI + AppKit (for menu bar app)
- **Speech Recognition**: Speech framework (SFSpeechRecognizer)
- **Audio**: AVFoundation (AVAudioEngine)
- **System Integration**: Accessibility API, Carbon (for global hotkeys)
- **Target**: macOS 13.0+ (Ventura)

## Project Structure

```
LocalDictation/
├── LocalDictation.xcodeproj
├── LocalDictation/
│   ├── App/
│   │   ├── LocalDictationApp.swift          # Main app entry point
│   │   ├── AppDelegate.swift                # Menu bar setup
│   │   └── Info.plist                       # Permissions & config
│   ├── Core/
│   │   ├── SpeechRecognitionManager.swift   # Speech recognition logic
│   │   ├── AudioEngineManager.swift         # Microphone input handling
│   │   ├── HotkeyManager.swift              # Global hotkey detection
│   │   └── TextInsertionManager.swift       # Accessibility API for text insertion
│   ├── UI/
│   │   ├── MenuBarView.swift                # Menu bar icon & menu
│   │   ├── SettingsView.swift               # Settings window
│   │   ├── PermissionsView.swift            # Permission requests UI
│   │   └── TranscriptionOverlay.swift       # Visual feedback during recording
│   ├── Models/
│   │   ├── AppSettings.swift                # User preferences
│   │   ├── TranscriptionSession.swift       # Recording session data
│   │   └── HotkeyConfiguration.swift        # Hotkey settings
│   └── Utilities/
│       ├── PermissionsManager.swift         # Check/request permissions
│       ├── AccessibilityHelper.swift        # Accessibility API helpers
│       └── Extensions.swift                 # Swift extensions
└── README.md
```

## Development Phases

### Phase 1: Project Setup & Permissions (Foundation)

**Goal**: Create the basic app structure and handle all required permissions.

**Tasks**:

1. Create new macOS app project in Xcode
   - Target: macOS 13.0+
   - Bundle identifier: `com.yourname.LocalDictation`
   - Enable App Sandbox with appropriate entitlements

2. Configure Info.plist with usage descriptions:

   ```xml
   <key>NSMicrophoneUsageDescription</key>
   <string>LocalDictation needs microphone access to transcribe your speech.</string>

   <key>NSSpeechRecognitionUsageDescription</key>
   <string>LocalDictation uses speech recognition to convert your voice to text.</string>
   ```

3. Create `PermissionsManager.swift`:
   - Check microphone authorization status
   - Check speech recognition authorization status
   - Check Accessibility API access
   - Request permissions with proper UI flow
   - Store permission states

4. Create `PermissionsView.swift`:
   - Display permission status for each requirement
   - Buttons to request/open System Settings
   - Visual indicators (checkmarks/warnings)
   - Instructions for enabling Accessibility access

5. Set up entitlements file:
   - Audio Input
   - User Selected Files (if needed)
   - Disable App Sandbox temporarily for Accessibility API testing

**Deliverable**: App launches, shows permissions screen, can request microphone and speech recognition permissions.

---

### Phase 2: Speech Recognition Core (Heart of the App)

**Goal**: Implement reliable speech-to-text transcription from microphone input.

**Tasks**:

1. Create `SpeechRecognitionManager.swift`:

   ```swift
   class SpeechRecognitionManager: ObservableObject {
       @Published var transcribedText: String = ""
       @Published var isRecording: Bool = false

       private var speechRecognizer: SFSpeechRecognizer?
       private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
       private var recognitionTask: SFSpeechRecognitionTask?

       func startRecognition()
       func stopRecognition()
       func cancelRecognition()
   }
   ```

2. Implement initialization:
   - Create `SFSpeechRecognizer` with user's locale
   - Check `isAvailable` and `supportsOnDeviceRecognition`
   - Handle recognizer unavailability gracefully

3. Implement `startRecognition()`:
   - Create `SFSpeechAudioBufferRecognitionRequest`
   - Set `shouldReportPartialResults = true` for real-time updates
   - Set `requiresOnDeviceRecognition = true` for privacy
   - Start recognition task with result handler
   - Publish transcribed text updates

4. Implement result handling:
   - Extract `bestTranscription.formattedString`
   - Handle partial results (update UI in real-time)
   - Handle final results (isFinal flag)
   - Handle errors (network issues, timeout, etc.)

5. Implement `stopRecognition()`:
   - End audio properly
   - Finalize recognition task
   - Clean up resources

6. Create `AudioEngineManager.swift`:

   ```swift
   class AudioEngineManager {
       private let audioEngine = AVAudioEngine()
       private var inputNode: AVAudioInputNode?

       func startAudioEngine(bufferCallback: @escaping (AVAudioPCMBuffer) -> Void)
       func stopAudioEngine()
   }
   ```

7. Implement audio capture:
   - Configure `AVAudioSession` for recording
   - Get input node from audio engine
   - Install tap on bus 0 with appropriate buffer size (1024)
   - Append buffers to recognition request
   - Handle audio engine errors

8. Add error handling:
   - Audio engine start failures
   - Recognition unavailable
   - Timeout handling (1-minute limit workaround)
   - Microphone access denied

**Deliverable**: Can start/stop recording, see transcribed text in console/debug UI.

---

### Phase 3: Global Hotkey Detection

**Goal**: Allow users to trigger dictation from anywhere using a keyboard shortcut.

**Tasks**:

1. Create `HotkeyManager.swift`:

   ```swift
   class HotkeyManager {
       private var eventTap: CFMachPort?
       private var runLoopSource: CFRunLoopSource?

       func registerHotkey(key: KeyCode, modifiers: EventModifiers, callback: @escaping () -> Void)
       func unregisterHotkey()
       func isAccessibilityEnabled() -> Bool
   }
   ```

2. Implement event tap for global keyboard monitoring:
   - Use `CGEvent.tapCreate` with appropriate event mask
   - Monitor key down events
   - Check for modifier keys (Fn, Cmd, Ctrl, etc.)
   - Requires Accessibility permissions

3. Create `HotkeyConfiguration.swift` model:

   ```swift
   struct HotkeyConfiguration: Codable {
       var keyCode: UInt16
       var modifiers: UInt32
       var displayString: String
   }
   ```

4. Implement default hotkey (Fn key):
   - Detect Fn key press (keyCode 63)
   - Handle key hold vs. tap
   - Implement "hold to record" behavior

5. Add hotkey customization:
   - Allow users to change hotkey in settings
   - Validate hotkey combinations
   - Prevent conflicts with system shortcuts
   - Save preferences to UserDefaults

6. Implement recording modes:
   - **Hold mode**: Record while key is held, stop on release
   - **Toggle mode**: Press once to start, press again to stop
   - Store mode preference

**Deliverable**: Can trigger recording from anywhere using Fn key (or custom hotkey).

---

### Phase 4: Text Insertion via Accessibility API

**Goal**: Insert transcribed text into the currently active application.

**Tasks**:

1. Create `TextInsertionManager.swift`:

   ```swift
   class TextInsertionManager {
       func insertText(_ text: String)
       func getActiveApplication() -> AXUIElement?
       func getFocusedElement() -> AXUIElement?
       func pasteText(_ text: String)
   }
   ```

2. Implement Accessibility API text insertion:
   - Get system-wide accessibility element
   - Find focused application using `AXUIElementCopyAttributeValue`
   - Get focused UI element (text field, text area, etc.)
   - Insert text using `AXUIElementSetAttributeValue` with `kAXValueAttribute`

3. Implement fallback: simulated typing:
   - Use `CGEvent.keyboardEvent` to simulate keystrokes
   - Type out text character by character
   - Handle special characters and punctuation
   - Add small delays between keystrokes for reliability

4. Implement clipboard-based insertion:
   - Copy text to clipboard using `NSPasteboard`
   - Simulate Cmd+V keystroke
   - Restore previous clipboard contents
   - Use as fallback when direct insertion fails

5. Add insertion mode selection:
   - Try direct Accessibility API first (fastest, most reliable)
   - Fall back to clipboard paste if direct fails
   - Fall back to simulated typing as last resort
   - Log which method was used for debugging

6. Handle edge cases:
   - Apps that don't support Accessibility API
   - Password fields (should not insert)
   - Read-only fields
   - Multi-line text areas vs. single-line fields

**Deliverable**: Transcribed text appears in active application automatically.

---

### Phase 5: Menu Bar UI & Visual Feedback

**Goal**: Create a polished menu bar app with visual feedback during recording.

**Tasks**:

1. Create `AppDelegate.swift` for menu bar app:

   ```swift
   class AppDelegate: NSObject, NSApplicationDelegate {
       var statusItem: NSStatusItem?
       var popover: NSPopover?

       func applicationDidFinishLaunching(_ notification: Notification)
   }
   ```

2. Implement menu bar icon:
   - Use SF Symbol: `mic.fill` or `waveform`
   - Change icon color/appearance when recording
   - Animate icon during active recording
   - Show badge for errors/warnings

3. Create menu bar menu:
   - "Start/Stop Dictation" toggle
   - "Settings..." option
   - "Permissions..." option
   - Separator
   - "Quit" option

4. Create `TranscriptionOverlay.swift`:

   ```swift
   struct TranscriptionOverlay: View {
       @Binding var isVisible: Bool
       @Binding var transcribedText: String
       @Binding var isRecording: Bool
   }
   ```

5. Implement floating overlay window:
   - Semi-transparent window that appears during recording
   - Shows real-time transcription
   - Displays recording indicator (animated waveform)
   - Shows "Swipe up to cancel" hint (if implementing)
   - Auto-positions near cursor or center of screen

6. Add visual states:
   - **Idle**: Menu bar icon normal
   - **Recording**: Icon animated, overlay visible
   - **Processing**: Spinner/progress indicator
   - **Error**: Red icon, error message in overlay
   - **Success**: Brief checkmark animation

7. Implement overlay animations:
   - Fade in/out transitions
   - Smooth text updates
   - Waveform animation during recording
   - Slide up to cancel gesture (optional)

**Deliverable**: Polished menu bar app with visual feedback during dictation.

---

### Phase 6: Settings & Preferences

**Goal**: Allow users to customize app behavior.

**Tasks**:

1. Create `AppSettings.swift` model:

   ```swift
   class AppSettings: ObservableObject {
       @AppStorage("hotkeyConfig") var hotkeyConfig: HotkeyConfiguration
       @AppStorage("recordingMode") var recordingMode: RecordingMode
       @AppStorage("insertionMode") var insertionMode: InsertionMode
       @AppStorage("showOverlay") var showOverlay: Bool
       @AppStorage("language") var language: String
       @AppStorage("launchAtLogin") var launchAtLogin: Bool
   }
   ```

2. Create `SettingsView.swift` with tabs:
   - **General**: Launch at login, show overlay
   - **Hotkey**: Customize recording hotkey, recording mode
   - **Recognition**: Language selection, on-device preference
   - **Insertion**: Insertion method preference
   - **About**: Version info, links

3. Implement hotkey recorder:
   - Text field that captures key combinations
   - Visual display of current hotkey
   - "Record" button to capture new hotkey
   - Validation and conflict detection

4. Implement language selection:
   - Fetch `SFSpeechRecognizer.supportedLocales()`
   - Display in picker/dropdown
   - Show which languages support on-device recognition
   - Update recognizer when language changes

5. Add insertion method preferences:
   - Radio buttons for: Auto, Accessibility API, Clipboard, Typing
   - Explanation of each method
   - Test button to verify insertion works

6. Implement launch at login:
   - Use `SMLoginItemSetEnabled` or Service Management framework
   - Toggle in settings
   - Verify it works after restart

7. Persist settings:
   - Use `@AppStorage` for simple values
   - Use `UserDefaults` for complex objects
   - Implement Codable for custom types

**Deliverable**: Fully functional settings window with all customization options.

---

### Phase 7: Error Handling & Edge Cases

**Goal**: Make the app robust and handle all failure scenarios gracefully.

**Tasks**:

1. Implement comprehensive error types:

   ```swift
   enum DictationError: LocalizedError {
       case microphoneAccessDenied
       case speechRecognitionDenied
       case accessibilityAccessDenied
       case recognizerUnavailable
       case audioEngineFailure
       case recognitionTimeout
       case insertionFailed
   }
   ```

2. Add error handling for permissions:
   - Show alerts when permissions are denied
   - Provide "Open System Settings" button
   - Disable features that require missing permissions
   - Show status in menu bar (warning icon)

3. Handle speech recognition errors:
   - Network unavailable (if not on-device)
   - Recognition timeout (1-minute limit)
   - Recognizer becomes unavailable mid-session
   - No speech detected
   - Audio quality too poor

4. Handle audio engine errors:
   - Microphone already in use by another app
   - Audio engine fails to start
   - Input node unavailable
   - Buffer overflow

5. Handle text insertion failures:
   - No active application
   - No focused text field
   - Accessibility API denied
   - Clipboard access issues

6. Implement retry logic:
   - Auto-retry on transient failures
   - Exponential backoff for repeated failures
   - User notification after max retries

7. Add logging:
   - Use `os.log` for system logging
   - Log all errors with context
   - Log permission states
   - Log which insertion method was used
   - Make logs accessible from settings

8. Implement graceful degradation:
   - If on-device recognition unavailable, use server
   - If Accessibility API fails, fall back to clipboard
   - If hotkey conflicts, show warning and use default

**Deliverable**: App handles all error scenarios without crashing.

---

### Phase 8: Testing & Polish

**Goal**: Ensure reliability and smooth user experience.

**Tasks**:

1. Test across different apps:
   - TextEdit, Notes, Mail
   - Safari, Chrome (web forms)
   - Slack, Discord, Messages
   - VS Code, Xcode
   - Terminal (if supported)

2. Test edge cases:
   - Very long recordings (>1 minute)
   - Very short recordings (<1 second)
   - Background noise
   - Multiple languages
   - Rapid start/stop cycles

3. Test permission flows:
   - Fresh install (no permissions)
   - Partial permissions granted
   - Permissions revoked mid-session
   - Accessibility access toggled

4. Performance testing:
   - CPU usage during recording
   - Memory usage over time
   - Battery impact
   - Startup time

5. Polish UI:
   - Consistent spacing and alignment
   - Smooth animations
   - Proper dark mode support
   - Accessibility labels for VoiceOver

6. Add keyboard shortcuts:
   - Cmd+, for Settings
   - Cmd+Q to quit
   - Esc to cancel recording

7. Create onboarding flow:
   - Welcome screen on first launch
   - Step-by-step permission requests
   - Quick tutorial on how to use
   - Test recording to verify setup

8. Write documentation:
   - README with setup instructions
   - Troubleshooting guide
   - FAQ for common issues
   - Privacy policy (data handling)

**Deliverable**: Polished, tested app ready for daily use.

---

## Key Implementation Details

### SFSpeechRecognizer Setup

```swift
// Initialize with locale
let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))

// Check availability
guard recognizer?.isAvailable == true else {
    // Handle unavailable
    return
}

// Check on-device support
if recognizer?.supportsOnDeviceRecognition == true {
    request.requiresOnDeviceRecognition = true
}
```

### Audio Engine Setup

```swift
let audioEngine = AVAudioEngine()
let inputNode = audioEngine.inputNode
let recordingFormat = inputNode.outputFormat(forBus: 0)

inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
    recognitionRequest?.append(buffer)
}

audioEngine.prepare()
try audioEngine.start()
```

### Global Hotkey Detection

```swift
let eventMask = (1 << CGEventType.keyDown.rawValue)
guard let eventTap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(eventMask),
    callback: { proxy, type, event, refcon in
        // Handle key event
        return Unmanaged.passRetained(event)
    },
    userInfo: nil
) else {
    // Accessibility access denied
    return
}
```

### Text Insertion via Accessibility API

```swift
// Get focused element
let systemWide = AXUIElementCreateSystemWide()
var focusedApp: CFTypeRef?
AXUIElementCopyAttributeValue(systemWide, kAXFocusedApplicationAttribute as CFString, &focusedApp)

var focusedElement: CFTypeRef?
AXUIElementCopyAttributeValue(focusedApp as! AXUIElement, kAXFocusedUIElementAttribute as CFString, &focusedElement)

// Insert text
let text = "transcribed text" as CFString
AXUIElementSetAttributeValue(focusedElement as! AXUIElement, kAXValueAttribute as CFString, text)
```

## Testing Checklist

- [ ] App launches without crashing
- [ ] All permissions can be requested
- [ ] Recording starts/stops reliably
- [ ] Transcription is accurate
- [ ] Text inserts into various apps
- [ ] Hotkey works system-wide
- [ ] Settings persist across launches
- [ ] Error messages are helpful
- [ ] UI is responsive
- [ ] No memory leaks
- [ ] Works on macOS 13, 14, 15

## Known Limitations

1. **1-minute timeout**: SFSpeechRecognizer has undocumented 1-minute limit for continuous recognition
2. **Device required**: Won't work in iOS Simulator (macOS should be fine)
3. **Accessibility required**: Text insertion requires Accessibility permissions
4. **Language support**: Limited to languages supported by SFSpeechRecognizer
5. **On-device availability**: Not all languages support on-device recognition

## Future Enhancements (Post-MVP)

- Upgrade to SpeechAnalyzer (iOS 26/macOS Tahoe) for better performance
- Custom vocabulary/phrases for better accuracy
- Text formatting commands ("new line", "period", etc.)
- Auto-punctuation improvements
- Multiple language support in single session
- Cloud sync of settings
- Keyboard maestro integration
- AppleScript support

## Resources

- [Apple Speech Framework Documentation](https://developer.apple.com/documentation/speech)
- [WWDC 2025: SpeechAnalyzer](https://developer.apple.com/videos/play/wwdc2025/277/)
- [Accessibility API Guide](https://developer.apple.com/documentation/applicationservices/axuielement)
- [SwiftSpeech Open Source Project](https://github.com/Cay-Zhang/SwiftSpeech)

---

This plan should give Claude Code everything needed to build a functional local dictation app. Start with Phase 1 and work sequentially through each phase. Good luck!
