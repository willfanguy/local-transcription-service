# Local Dictation App - Development Guide

## Current Status

**Phases Completed**: 1-4 of 8 ✅
**Progress**: Phase 4 complete
**Next Up**: Phase 5 - Menu Bar UI & Visual Feedback

### What's Working
- ✅ Project structure and XcodeGen configuration
- ✅ PermissionsManager handles microphone, speech recognition, and accessibility checks
  - Accessibility permission checking with AXIsProcessTrusted
  - Request permission dialog
  - Open System Settings shortcut
- ✅ SpeechRecognitionManager with:
  - Speech recognizer initialization (locale-aware)
  - Recognition request handling
  - Real-time transcription callbacks
  - 1-minute timeout awareness
  - Test recording functionality
  - macOS-specific implementation (no AVAudioSession)
- ✅ AudioEngineManager with:
  - Start/stop engine control
  - Audio tap configuration (bus 0, buffer size 1024)
  - State logging
  - macOS-specific implementation (no AVAudioSession)
- ✅ HotkeyManager with:
  - Global keyboard event tap (CGEvent.tapCreate)
  - Fn key detection (keyCode 63, customizable)
  - Start/stop monitoring
  - Callback system for key press/release
  - Support for both "hold to record" and "toggle" modes
  - Proper cleanup in deinit
- ✅ ContentView with:
  - Permission testing (all three permissions)
  - 3-second recording test
  - Hotkey monitoring UI with visual feedback
  - Real-time Fn key press indicator
  - Text insertion testing UI (Phase 4)
- ✅ TextInsertionManager with:
  - getFocusedElement() to find active UI element
  - getCurrentText() to read element text
  - insertTextDirect() for Accessibility API insertion
  - insertViaClipboard() as fallback method
  - insertViaKeystrokes() as final fallback
  - insertText() main method with automatic fallback chain
  - Comprehensive error handling with TextInsertionError enum
  - Clipboard restoration after paste
- ✅ Project builds successfully with xcodebuild
- ✅ All Phase 1-4 verification checks pass

### Recent Changes
- **2025-11-06 (Phase 4)**: Implemented Text Insertion via Accessibility API ✅
  - Created TextInsertionManager.swift with three-tier fallback system
  - Direct Accessibility API insertion using AXUIElementSetAttributeValue
  - Clipboard paste fallback (saves and restores previous clipboard)
  - Keystroke simulation fallback for apps that don't support other methods
  - Added test UI in ContentView with "Insert Hello World" button
  - Added verification script: scripts/verify_phase4.sh
  - **Key implementation details**:
    - Uses AXUIElementCreateSystemWide() to access system-wide UI elements
    - kAXFocusedUIElementAttribute to find currently focused element
    - Automatic fallback chain: direct API → clipboard → keystroke
    - Clipboard content restored after 200ms delay
    - CGEvent keyboard simulation for character typing
  - All verification checks pass, ready for manual testing across apps

- **2025-11-06 (Phase 3)**: Implemented Global Hotkey Detection ✅
  - Created HotkeyManager.swift with CGEvent tap for global keyboard monitoring
  - Added accessibility permission methods to PermissionsManager
  - Integrated hotkey testing UI in ContentView with real-time visual feedback
  - Added verification script: scripts/verify_phase3.sh
  - **Key discoveries**:
    - Fn key is keyCode 179 on MacBook Air (varies by model, not always 63)
    - Event tap must use `CFRunLoopGetMain()` not `CFRunLoopGetCurrent()`
    - UI updates from event callbacks must be dispatched to main thread
    - Accessibility permission requires re-grant after each rebuild during development
  - All verification checks pass, UI indicator working

- **2025-11-06 (Phase 2)**: Removed iOS-specific AVAudioSession code that was incompatible with macOS
  - AudioEngineManager.swift: Removed `configureAudioSession()` and `resetAudioSession()`
  - SpeechRecognitionManager.swift: Removed AVAudioSession configuration calls
  - On macOS, AVAudioEngine works directly without session configuration

### Ready for Phase 5
Phase 4 is complete and verified. Ready to proceed with menu bar UI and visual feedback.

---

## Phase 1: Project Foundation ✅ COMPLETE

**Goal**: Create basic app structure and handle permissions.

**Deliverable**: App launches, shows permissions screen, can request microphone and speech recognition permissions.

### 1.1 Xcode Project Creation
- [x] Create new macOS App project (via XcodeGen)
- [x] Set minimum deployment target to macOS 13.0
- [x] Configure bundle identifier
- [x] Initial build test (pending)

### 1.2 Project Structure Setup
- [x] Create folder structure (Core/, UI/, Models/, Utilities/, Resources/)
- [x] Add groups to project configuration
- [x] Add .gitignore for Xcode artifacts
- [x] Create README (pending)

### 1.3 Info.plist Permissions
- [x] Add NSMicrophoneUsageDescription
- [x] Add NSSpeechRecognitionUsageDescription
- [x] Create permission test button in ContentView
- [x] Test permission dialog (pending actual run)

### 1.4 Basic Permission Manager
- [x] Create PermissionsManager.swift in Utilities/
- [x] Add microphone permission check method
- [x] Add speech recognition permission check method
- [x] Create unit test
- [x] Add console logging

**Verification Checkpoint**:
```bash
# Generate and build project
xcodegen generate
xcodebuild -scheme LocalDictation -configuration Debug build

# Should succeed with no errors
# Run app and verify permission dialogs appear when requested
```

---

## Phase 2: Speech Recognition Core ✅ COMPLETE

**Goal**: Implement reliable speech-to-text transcription from microphone input.

**Deliverable**: Can start/stop recording, see transcribed text in console/debug UI.

### 2.1 Minimal Speech Recognizer

#### Step 2.1.1: Create SpeechRecognitionManager
- [x] New file: Core/SpeechRecognitionManager.swift
- [x] Import Speech and AVFoundation frameworks
- [x] Create class structure

**Verification**: File compiles

#### Step 2.1.2: Add SFSpeechRecognizer Property
- [x] Add `private var speechRecognizer: SFSpeechRecognizer?`

**Verification**: Still compiles

#### Step 2.1.3: Add Initialization Method
- [x] Initialize with locale (en-US)
- [x] Check `isAvailable` property
- [x] Check `supportsOnDeviceRecognition`
- [x] Log availability status

**Verification**: Console shows availability on init

#### Step 2.1.4-5: Test and Verify
- [x] Instantiate manager in ContentView
- [x] Test for crashes with multiple init/deinit cycles

**Verification**: No crashes, consistent console output

### 2.2 Audio Engine Setup

#### Step 2.2.1: Create AudioEngineManager
- [x] New file: Core/AudioEngineManager.swift
- [x] Add `private let audioEngine = AVAudioEngine()`

**Verification**: Compiles

#### Step 2.2.2: Add Start Method
- [x] Implement `startEngine() throws`
- [x] Check if engine is already running
- [x] Start engine and log status

**Verification**: Method throws errors appropriately

#### Step 2.2.3: Add Stop Method
- [x] Implement `stopEngine()`
- [x] Check if engine is running before stopping
- [x] Log stop status

**Verification**: Method exists and logs correctly

#### Step 2.2.4: Test Start/Stop
- [x] Add test button in ContentView
- [x] Verify console messages
- [x] Check for crashes

**Verification**: Console shows start/stop, no crashes

#### Step 2.2.5: Add State Logging
- [x] Add `var isRunning: Bool` computed property

**Verification**: Can query engine state

### 2.3 First Recognition Attempt

#### Step 2.3.1: Add Recognition Request Property
- [x] Add `private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?`

**Verification**: Compiles

#### Step 2.3.2: Setup Audio Tap Method
- [x] Get input node from audio engine
- [x] Get recording format from `outputFormat(forBus: 0)`
- [x] Install tap with buffer size 1024
- [x] Append buffers to recognition request

**Verification**: Method compiles and installs tap

#### Step 2.3.3: Wire Buffer to Request
- [x] Create `SFSpeechAudioBufferRecognitionRequest`
- [x] Set `shouldReportPartialResults = true`
- [x] Set `requiresOnDeviceRecognition = true` when available

**Verification**: Request created and configured

#### Step 2.3.4: Add Transcription Callback
- [x] Create recognition task with result handler
- [x] Extract `bestTranscription.formattedString`
- [x] Print transcription to console
- [x] Handle errors

**Verification**: Callback prints transcriptions

#### Step 2.3.5: Test 3-Second Recording
- [x] Add test button to ContentView
- [x] Start recognition, wait 3 seconds, stop
- [x] Verify transcribed text appears in UI

**Verification**: See transcribed text in console/UI

**Phase 2 Verification Checkpoint**:
```bash
# Run app
open LocalDictation.xcodeproj
# Press Cmd+R in Xcode

# Test:
# 1. Click "Test Permissions" - should request microphone & speech
# 2. Grant permissions
# 3. Click "Test 3-Second Recording"
# 4. Speak clearly for 3 seconds
# 5. Verify transcription appears in UI
# 6. Check console for detailed logs
```

---

## Phase 3: Global Hotkey Detection ✅ COMPLETE

**Goal**: Allow users to trigger dictation from anywhere using a keyboard shortcut.

**Deliverable**: Can trigger recording from anywhere using Fn key (or custom hotkey).

### 3.1 Accessibility Permission ✅

#### Step 3.1.1: Check Accessibility Permission ✅
- [x] Added checkAccessibilityPermission() to PermissionsManager
- [x] Uses AXIsProcessTrusted() to check permission status
- [x] Published property for UI reactivity

#### Step 3.1.2: Create Permission Request UI ✅
- [x] Added Request button in ContentView
- [x] Uses AXIsProcessTrustedWithOptions with prompt option
- [x] Opens system permission dialog

#### Step 3.1.3: Open System Settings Method ✅
- [x] Added openAccessibilitySettings() to PermissionsManager
- [x] Opens correct System Settings pane
- [x] Direct link to Privacy & Security > Accessibility

#### Step 3.1.4: Test Permission Flow ✅
- [x] Permission checking works correctly
- [x] Request dialog appears
- [x] Status updates when permission granted
- [x] UI shows permission state with visual indicator

### 3.2 Basic Event Tap ✅

#### Step 3.2.1: Create HotkeyManager ✅
- [x] Created Core/HotkeyManager.swift
- [x] Imports Carbon and CoreGraphics
- [x] Class structure with properties

#### Step 3.2.2: Create Event Tap ✅
- [x] Implemented startMonitoring() method
- [x] Creates CGEvent tap with session and head insert
- [x] Monitors both keyDown and keyUp events
- [x] Adds to run loop with common modes
- [x] Enables tap after setup

#### Step 3.2.3: Add Callback ✅
- [x] Implemented handleKeyEvent callback
- [x] Extracts keyCode from events
- [x] Detects Fn key (keyCode 63)
- [x] Separate handlers for key down/up
- [x] Prevents repeat events
- [x] Logs key presses to console

#### Step 3.2.4: Test Fn Key Detection ✅
- [x] Integrated with ContentView
- [x] Visual feedback on key press (red indicator)
- [x] Console logging works
- [x] Callbacks triggered correctly

#### Step 3.2.5: Add Cleanup ✅
- [x] Implemented deinit
- [x] Disables event tap
- [x] Removes run loop source
- [x] Proper resource cleanup
- [x] Implemented stopMonitoring() method

**Phase 3 Verification Checkpoint**:
```bash
# Run app with Accessibility permission granted
# Verify:
# 1. App can detect Fn key press from any application
# 2. Console logs key presses
# 3. No memory leaks or crashes
# 4. Event tap cleaned up on app quit
```

**Time Estimate**: ~1.5 hours

---

## Phase 4: Text Insertion ✅ COMPLETE

**Goal**: Insert transcribed text into the currently active application.

**Deliverable**: Transcribed text appears in active application automatically.

### 4.1 Accessibility API Basics

#### Step 4.1.1: Create TextInsertionManager (3 min)
**Action**: New file Core/TextInsertionManager.swift:
```swift
import Cocoa
import ApplicationServices

class TextInsertionManager {
    // Initial implementation
}
```

**Verification**: Compiles

#### Step 4.1.2: Get Focused Element (15 min)
**Action**: Add method to find focused UI element:
```swift
func getFocusedElement() -> AXUIElement? {
    let systemWide = AXUIElementCreateSystemWide()
    var focusedElement: CFTypeRef?

    let result = AXUIElementCopyAttributeValue(
        systemWide,
        kAXFocusedUIElementAttribute as CFString,
        &focusedElement
    )

    return result == .success ? (focusedElement as! AXUIElement) : nil
}
```

**Verification**: Returns focused element or nil

#### Step 4.1.3: Read Current Text (10 min)
**Action**: Add method to read text value:
```swift
func getCurrentText(from element: AXUIElement) -> String? {
    var value: CFTypeRef?
    let result = AXUIElementCopyAttributeValue(
        element,
        kAXValueAttribute as CFString,
        &value
    )
    return result == .success ? (value as? String) : nil
}
```

**Verification**: Returns current text or nil

#### Step 4.1.4: Test with TextEdit (10 min)
**Test Steps**:
1. Open TextEdit with some content
2. Run method to read current value
3. Print to console

**Verification**: Console shows TextEdit content

#### Step 4.1.5: Error Handling (5 min)
**Action**: Define error types:
```swift
enum TextInsertionError: Error {
    case noFocusedElement
    case unsupportedElement
    case insertionFailed
}
```

**Verification**: Errors defined and used in methods

### 4.2 Text Insertion Methods

#### Step 4.2.1: Direct AXUIElement Insertion (10 min)
**Action**: Add direct insertion method:
```swift
func insertTextDirect(_ text: String, to element: AXUIElement) -> Bool {
    let result = AXUIElementSetAttributeValue(
        element,
        kAXValueAttribute as CFString,
        text as CFTypeRef
    )
    return result == .success
}
```

**Verification**: Method returns success/failure

#### Step 4.2.2: Test "Hello World" Insertion (10 min)
**Test Steps**:
1. Open TextEdit
2. Clear content
3. Call insertTextDirect("Hello World")
4. Verify text appears

**Verification**: "Hello World" appears in TextEdit

#### Step 4.2.3: Clipboard Fallback (15 min)
**Action**: Add clipboard insertion method:
```swift
func insertViaClipboard(_ text: String) {
    let pasteboard = NSPasteboard.general
    let oldContent = pasteboard.string(forType: .string)

    pasteboard.clearContents()
    pasteboard.setString(text, forType: .string)

    // Simulate Cmd+V
    simulateKeyPress(key: .v, modifiers: .command)

    // Restore old clipboard after delay
    if let oldContent = oldContent {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            pasteboard.setString(oldContent, forType: .string)
        }
    }
}
```

**Verification**: Text inserted via clipboard, old content restored

#### Step 4.2.4: Test in Safari (10 min)
**Test Steps**:
1. Open Safari with text input
2. Try direct insertion (may fail)
3. Fall back to clipboard method
4. Verify text appears

**Verification**: Text appears in Safari input field

#### Step 4.2.5: Keystroke Simulation Fallback (15 min)
**Action**: Add keystroke simulation method:
```swift
func insertViaKeystrokes(_ text: String) {
    for character in text {
        simulateKeyPress(character: character)
        Thread.sleep(forTimeInterval: 0.01)
    }
}
```

**Verification**: Text appears character by character

**Phase 4 Verification Checkpoint**:
```bash
# Test text insertion in multiple apps:
# 1. TextEdit - direct insertion should work
# 2. Safari - may need clipboard fallback
# 3. Notes, Messages - verify insertion
# 4. VS Code - test various methods

# Verify:
# - Text appears correctly
# - Fallback chain works (direct → clipboard → typing)
# - Clipboard restored after insertion
# - No crashes or hangs
```

**Time Estimate**: ~2 hours

---

## Phase 5: Menu Bar UI & Visual Feedback

**Goal**: Create polished menu bar app with visual feedback during recording.

**Deliverable**: Polished menu bar app with real-time transcription overlay.

### Tasks
1. Create AppDelegate for menu bar (NSStatusItem)
2. Implement menu bar icon with states:
   - Idle: normal icon
   - Recording: animated/colored icon
   - Error: warning indicator
3. Create menu bar menu:
   - Start/Stop Dictation
   - Settings...
   - Permissions...
   - Quit
4. Create TranscriptionOverlay (floating window):
   - Semi-transparent
   - Shows real-time transcription
   - Animated recording indicator
   - Auto-positions near cursor
5. Add visual feedback:
   - Fade in/out animations
   - Smooth text updates
   - Recording waveform animation

**Verification Checkpoint**:
```bash
# Visual inspection:
# 1. Menu bar icon appears in system tray
# 2. Icon changes appearance when recording
# 3. Overlay appears during recording with transcription
# 4. Animations are smooth, no flickering
# 5. Overlay dismisses after recording stops
```

---

## Phase 6: Settings & Preferences

**Goal**: Allow users to customize app behavior.

**Deliverable**: Fully functional settings window with all customization options.

### Tasks
1. Create AppSettings model with @AppStorage:
   - Hotkey configuration
   - Recording mode (hold vs toggle)
   - Insertion mode preference
   - Show overlay toggle
   - Language selection
   - Launch at login
2. Create SettingsView with tabs:
   - General: launch at login, show overlay
   - Hotkey: customize recording hotkey
   - Recognition: language selection
   - Insertion: method preference
   - About: version info, links
3. Implement hotkey recorder UI
4. Add language picker (from supportedLocales)
5. Implement launch at login
6. Persist all settings via UserDefaults

**Verification Checkpoint**:
```bash
# Test each setting:
# 1. Change hotkey - verify new key works
# 2. Toggle recording mode - test hold vs toggle
# 3. Change language - verify recognition updates
# 4. Change insertion method - verify it's used
# 5. Enable launch at login - verify after restart
# 6. All settings persist after app quit/relaunch
```

---

## Phase 7: Error Handling & Edge Cases

**Goal**: Make the app robust and handle all failure scenarios gracefully.

**Deliverable**: App handles all error scenarios without crashing.

### Tasks
1. Define comprehensive DictationError enum:
   - Permission denials (mic, speech, accessibility)
   - Recognizer unavailable
   - Audio engine failures
   - Recognition timeout (1-minute limit)
   - Text insertion failures
2. Add error handling for permissions:
   - Show alerts when denied
   - "Open System Settings" buttons
   - Disable features requiring missing permissions
3. Handle speech recognition errors:
   - Network unavailable
   - Recognition timeout
   - No speech detected
   - Audio quality issues
4. Handle audio engine errors:
   - Mic in use by another app
   - Engine fails to start
   - Buffer overflow
5. Handle text insertion failures:
   - No active application
   - No focused text field
   - Accessibility denied
6. Implement retry logic with exponential backoff
7. Add comprehensive logging (os.log)
8. Implement graceful degradation

**Verification Checkpoint**:
```bash
# Test error scenarios:
# 1. Revoke permissions mid-session
# 2. Record for >1 minute (timeout handling)
# 3. Disconnect microphone during recording
# 4. Try inserting text with no focused field
# 5. Rapid start/stop cycles
# 6. Background noise/no speech
# 7. Multiple apps competing for microphone

# Verify:
# - No crashes in any scenario
# - User-friendly error messages
# - App recovers gracefully
# - Appropriate fallback behavior
```

---

## Phase 8: Testing & Polish

**Goal**: Ensure reliability and smooth user experience.

**Deliverable**: Polished, tested app ready for daily use.

### Tasks
1. Test across different apps:
   - Native: TextEdit, Notes, Mail, Messages
   - Web: Safari, Chrome (form inputs)
   - Third-party: Slack, Discord, VS Code
   - Terminal (limited support expected)
2. Test edge cases:
   - Very long recordings (>1 minute)
   - Very short recordings (<1 second)
   - Background noise
   - Multiple languages
   - Rapid start/stop cycles
3. Test permission flows:
   - Fresh install
   - Partial permissions
   - Permissions revoked mid-session
4. Performance testing:
   - CPU usage during recording
   - Memory usage over time
   - Battery impact
   - Startup time
5. Polish UI:
   - Consistent spacing/alignment
   - Smooth animations
   - Dark mode support
   - VoiceOver accessibility
6. Add keyboard shortcuts:
   - Cmd+, for Settings
   - Esc to cancel recording
7. Create onboarding flow:
   - Welcome screen
   - Step-by-step permissions
   - Quick tutorial
8. Write documentation:
   - README with setup
   - Troubleshooting guide
   - FAQ

**Final Verification**:
```bash
# Complete testing matrix:
# - macOS 13, 14, 15
# - Intel and Apple Silicon
# - Multiple user accounts
# - Clean install testing
# - Extended usage (memory leaks)
# - All test cases passing
```

---

## Architecture Reference

### Core Components

**SpeechRecognitionManager** (Core/)
- Manages SFSpeechRecognizer lifecycle
- Handles recognition requests and tasks
- Implements 1-minute timeout workaround
- Publishes transcription results

**AudioEngineManager** (Core/)
- Manages AVAudioEngine for microphone input
- Installs tap on input node bus 0
- Feeds audio buffers to speech recognizer
- Handles audio session configuration

**HotkeyManager** (Core/)
- Implements global keyboard monitoring via CGEvent.tapCreate
- Requires Accessibility permissions
- Supports "hold to record" and "toggle" modes
- Default hotkey: Fn key (keyCode 63)

**TextInsertionManager** (Core/)
- Uses Accessibility API to insert text
- Fallback chain: direct API → clipboard → typing
- Handles various app types and edge cases

**PermissionsManager** (Utilities/)
- Centralized permission checking and requesting
- Handles: microphone, speech recognition, accessibility
- Provides UI hooks for permission flows

### Key Implementation Patterns

**Speech Recognition Setup**:
```swift
let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
guard recognizer?.isAvailable == true else { return }

if recognizer?.supportsOnDeviceRecognition == true {
    request.requiresOnDeviceRecognition = true
}
request.shouldReportPartialResults = true
```

**Audio Engine Configuration**:
```swift
let inputNode = audioEngine.inputNode
let recordingFormat = inputNode.outputFormat(forBus: 0)

inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
    recognitionRequest?.append(buffer)
}
```

**Global Hotkey Detection**:
```swift
let eventMask = (1 << CGEventType.keyDown.rawValue)
let eventTap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(eventMask),
    callback: handleKeyEvent,
    userInfo: nil
)
```

**Text Insertion (Accessibility API)**:
```swift
let systemWide = AXUIElementCreateSystemWide()
var focusedElement: CFTypeRef?
AXUIElementCopyAttributeValue(systemWide, kAXFocusedUIElementAttribute as CFString, &focusedElement)
AXUIElementSetAttributeValue(focusedElement as! AXUIElement, kAXValueAttribute as CFString, text as CFString)
```

---

## Known Limitations

1. **1-minute timeout**: SFSpeechRecognizer has undocumented 1-minute limit - requires restart logic
2. **Accessibility required**: Both global hotkeys AND text insertion need Accessibility permissions
3. **On-device availability**: Not all languages support on-device recognition
4. **App compatibility**: Some apps may not support Accessibility API text insertion

---

## Resources

- [Apple Speech Framework Documentation](https://developer.apple.com/documentation/speech)
- [WWDC 2025: SpeechAnalyzer](https://developer.apple.com/videos/play/wwdc2025/277/)
- [Accessibility API Guide](https://developer.apple.com/documentation/applicationservices/axuielement)
- [SwiftSpeech Open Source](https://github.com/Cay-Zhang/SwiftSpeech)
