# Local Dictation App - Development Guide

## Current Status

**Phases Completed**: 1-6 of 8 ✅
**Progress**: Phase 6 complete - Settings & Preferences implemented
**Next Up**: Fix critical EXC_BAD_ACCESS crash bug (blocking all usage), then Phase 7 - Error Handling & Edge Cases
**Current Blocker**: 🔴 **CRITICAL BUG** - Second recording crashes with EXC_BAD_ACCESS in autorelease pool

### Quick Summary for Fresh Context

**What Works**:
- ✅ Settings window with 5 tabs (General, Hotkey, Recognition, Insertion, About)
- ✅ Settings persist via UserDefaults
- ✅ Hotkey monitoring (Fn key, fixed permission ordering bug)
- ✅ First recording: overlay shows, captures speech, detects silence gracefully, inserts text
- ✅ Text insertion via Accessibility API (direct method works in most apps)

**What's Broken**:
- 🔴 **CRITICAL**: Second recording crashes with EXC_BAD_ACCESS in autorelease pool (see detailed investigation below)
- ⚠️ Permissions flow broken - not requesting microphone/speech recognition properly, only accessibility
- ⚠️ Filler word removal not working
- ⚠️ Automatic punctuation not working
- ⚠️ Settings "Change Hotkey" button doesn't capture keys (use Debug menu instead)
- ⚠️ Debug key logging not showing in console

**Last Test Session** (2025-11-06):
1. Restarted app after permission ordering fix - Fn key worked
2. First recording in Terminal: worked perfectly, detected "No speech detected", recovered
3. Second recording attempt: locked up completely, overlay stuck, had to force quit
4. Confirmed lockup happens on every second recording attempt

### 🔴 CRITICAL BUG: Second Recording Crashes with EXC_BAD_ACCESS

**Symptom**: First recording works perfectly. Second recording starts setup ("Recognition started successfully"), then immediately crashes with EXC_BAD_ACCESS in autorelease pool.

**Crash Pattern**:
```
* thread #1, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=1, address=0x...)
  * frame #0: libobjc.A.dylib`objc_release + 16
    frame #1: libobjc.A.dylib`AutoreleasePoolPage::releaseUntil(objc_object**) + 204
    frame #2: libobjc.A.dylib`objc_autoreleasePoolPop + 244
    frame #3: CoreFoundation`_CFAutoreleasePoolPop + 32
    frame #4: Foundation`-[NSAutoreleasePool drain] + 136
    frame #5: AppKit`-[NSApplication run] + 416
```

**Console Pattern** (first recording completes, second crashes):
```
[First Recording]
Recognition started successfully
Recording stopped
Recognition task completed (final: false, error: true)  ← Fires AFTER cleanup

[Second Recording - Initial behavior]
Recognition started successfully  ← CRASHED HERE (attempts 1-7)

[Second Recording - After autoreleasepool changes (attempt 8)]
[HotkeyManager] Hotkey pressed (keyCode: 63)
← CRASHES HERE NOW (before overlay, before any recording setup)
```

**Key Observations**:
1. The first recording's completion handler fires **AFTER** stopRecognition() completes, suggesting async autoreleased objects linger
2. After autoreleasepool changes (attempt 8), crash moved EARLIER - now crashes immediately on hotkey press for second recording, before even reaching AppDelegate's hotkey handler or showing UI
3. This suggests the autorelease corruption is so severe that even accessing manager objects (speechManager, audioManager) in the hotkey callback triggers the crash

**Attempted Fixes** (all failed):
1. ✗ Removed `testRecognition()`, switched to `startRecognition()` - still crashed
2. ✗ Added `audioEngine.reset()` after stopping - still crashed
3. ✗ Moved `audioEngine.reset()` to before starting - still crashed
4. ✗ Removed redundant `removeTap()` call from start - still crashed
5. ✗ Added completion handler guards for cancelled tasks - still crashed
6. ✗ Wrapped cleanup in `autoreleasepool { }` - still crashed
7. ✗ Wrapped start sequence in `autoreleasepool { }` - MADE IT WORSE (crash moved earlier)
8. ✗ Combined: aggressive autoreleasepool boundaries everywhere - MADE IT WORSE (now crashes on hotkey press before any setup)

**Current Theory**:
The autorelease pool from the first recording's completion handler contains corrupted objects (likely AVAudioEngine or SFSpeechRecognizer internals). Initially crashed after "Recognition started successfully" during pool drain. After adding autoreleasepool boundaries, crash moved EARLIER to immediately on hotkey press, suggesting the corruption is so deep that even accessing the manager objects triggers it. The autoreleasepool changes may have accelerated when the corrupted objects get released, but didn't fix the underlying corruption.

**Latest Code State** (LocalDictation/Core/SpeechRecognitionManager.swift):
- Cleanup wrapped in `autoreleasepool { }` with forced double-drain
- Start sequence wrapped in `autoreleasepool { }` for clean boundaries
- Removed `reset()` calls entirely
- Added explicit cancel + nil old objects before creating new ones
- All operations synchronous on main thread (no background dispatch)

**Next Steps to Try**:
1. **Add delay between recordings** - Test if waiting 1-2 seconds allows autorelease pool to naturally drain
2. **Don't reuse AVAudioEngine** - Create fresh engine for each recording (expensive but may work)
3. **Investigate AVAudioEngine internals** - Check Apple forums/docs for known reuse issues
4. **Try older AVAudioEngine patterns** - Look for deprecated but more stable APIs
5. **Consider alternative frameworks** - Evaluate if Audio Toolbox or lower-level APIs avoid this issue

**Files Involved**:
- `LocalDictation/Core/SpeechRecognitionManager.swift` (lines 138-313)
- `LocalDictation/AppDelegate.swift` (startRecording/stopRecording methods)

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
  - **Automatic punctuation** (addsPunctuation = true)
  - 1-minute timeout awareness
  - Test recording functionality
  - macOS-specific implementation (no AVAudioSession)
- ✅ AudioEngineManager with:
  - Start/stop engine control
  - Audio tap configuration (bus 0, buffer size 1024)
  - State logging
  - macOS-specific implementation (no AVAudioSession)
- ✅ HotkeyManager with:
  - **NSEvent monitors** (local + global) for better key detection
  - Monitors keyDown, keyUp, and flagsChanged events
  - Fn key detection (keyCode 63 default, customizable)
  - Debug mode to identify key codes
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
- ✅ AppDelegate with NSStatusItem for menu bar app:
  - Menu bar icon with dynamic states (idle/recording/error)
  - Menu with Start/Stop Dictation, Settings, Permissions, Quit
  - **Debug tools**: Log All Keys, Change Hotkey KeyCode, Check Status
  - Integration with all managers (speech, hotkey, text insertion)
  - **Automatic transcription cleaning** before insertion
  - Full "hold to record" workflow with Fn key
- ✅ TranscriptionOverlay floating window:
  - Semi-transparent overlay with rounded corners
  - Real-time transcription display
  - Animated recording indicator (pulsing red dot)
  - Auto-positions near cursor
  - Shows/hides during recording
- ✅ PermissionsView for Permissions menu:
  - Visual permission status for all three permissions
  - Quick access to grant/check permissions
  - "Open Settings" buttons where applicable
- ✅ TranscriptionProcessor for text cleanup:
  - Removes filler words (um, uh, like, you know, etc.)
  - Cleans up spacing and punctuation
  - Capitalizes after periods
  - Applied automatically before text insertion
- ✅ Project builds successfully with xcodebuild
- ✅ All Phase 1-6 verification checks pass
- ⚠️ **App partially functional** - first recording works, but locks up on subsequent recordings (critical bug)
- ✅ AppSettings model with @AppStorage persistence:
  - General settings: launch at login, show overlay toggle
  - Hotkey configuration: customizable key code
  - Recording mode: hold vs toggle
  - Recognition language: 30+ supported languages
  - Insertion method preference: auto, direct, clipboard, typing
- ✅ SettingsView with 5 tabs:
  - General tab with startup and overlay settings
  - Hotkey tab with key code configuration
  - Recognition tab with language picker
  - Insertion tab with method selection
  - About tab with app info and links
- ✅ Settings integrated with all managers:
  - AppDelegate uses settings for hotkey, recording mode, overlay visibility
  - SpeechRecognitionManager supports language switching
  - TextInsertionManager respects insertion method preference
  - Settings persist via UserDefaults automatically

### Other Known Bugs (Non-Blocking)

**High Priority**:
- ⚠️ **Permissions flow broken** (2025-11-06): App no longer requests microphone/speech recognition permissions properly. Only shows accessibility dialog. Permissions get granted eventually but flow is messy with multiple dialogs.
  - Console shows "Microphone permission status: Not Determined" repeatedly
  - No permission request dialog appears for mic/speech
  - Eventually permissions get authorized but unclear how
  - Needs: Review permission request flow in PermissionsManager
- ⚠️ **Filler word removal not working**: TranscriptionProcessor is implemented but filler words are not being removed from transcriptions
- ⚠️ **Automatic punctuation not working**: `addsPunctuation = true` is set but punctuation is not appearing in transcriptions

**Medium Priority**:
- ⚠️ **Debug key logging not showing** (2025-11-06): "Debug: Log All Keys" menu item doesn't output to console. Unclear if monitoring is working or just logging broken.
- ⚠️ **Change hotkey button doesn't recognize key presses**: In Settings > Hotkey tab, clicking "Change Hotkey" shows waiting state but doesn't capture key presses (workaround: use Debug menu "Change Hotkey KeyCode...")
- ⚠️ **Terminal text insertion compatibility**: Terminal likely doesn't support accessibility text insertion properly, may cause audio/recognition issues

**Low Priority**:
- ⚠️ **Escape key emergency cancel added but needs testing** (2025-11-06): Added Escape key monitor to force-stop stuck recordings, but hasn't been tested since crash happens before user can press Escape

### Recent Changes

- **2025-11-06 (EXC_BAD_ACCESS Investigation)**: Critical Crash Bug - 8 Failed Fix Attempts
  - **Problem**: Second recording crashes with EXC_BAD_ACCESS in autorelease pool immediately after "Recognition started successfully"
  - **Investigation approach**: Iterative debugging with 8 distinct fix attempts, testing each with full app restart
  - **Fix attempts** (all failed):
    1. Changed from `testRecognition()` to `startRecognition()` directly
    2. Added `audioEngine.reset()` to cleanup sequence
    3. Moved `reset()` from cleanup to start (before new recording)
    4. Removed redundant `removeTap()` call from start
    5. Added completion handler guards to ignore cancelled tasks
    6. Wrapped cleanup in `autoreleasepool { }` with double-drain
    7. Wrapped start sequence in `autoreleasepool { }`
    8. Removed all threading complexity, made everything synchronous on main thread
  - **Key discovery**: Completion handler from first recording fires AFTER stopRecognition() completes, suggesting async autorelease objects linger and corrupt second recording
  - **Latest code state**: Aggressive autoreleasepool boundaries + explicit object cleanup + main-thread-only execution
  - **Status**: Still crashing. Needs fundamentally different approach (delay, fresh engine, or alternative framework)
  - **Other bugs discovered**:
    - Permissions flow broken (mic/speech not requested properly)
    - Debug key logging not outputting to console
    - Escape key monitor added but untested due to crash
  - **User feedback**: "please ultrathink this through before I start it up again" - need better pre-testing strategy

- **2025-11-06 (Phase 6 Post-Implementation)**: Bug Fixes & Testing
  - **Fixed hotkey monitoring not starting**: Reordered `applicationDidFinishLaunching` to check permissions BEFORE setting up managers. Hotkey monitoring was failing because `accessibilityPermissionStatus` was uninitialized when `setupManagers()` checked it.
  - **Confirmed working**: Settings window opens from menu bar, all 5 tabs accessible
  - **Confirmed working**: First recording works correctly, detects "No speech detected", overlay dismisses properly, text insertion succeeds
  - **Discovered critical bug**: Second recording crashes with EXC_BAD_ACCESS - began extensive investigation (see above)
  - **Testing notes**:
    - Direct text insertion works in most apps
    - Terminal may have audio/accessibility compatibility issues
    - Toggle recording mode not yet tested

- **2025-11-06 (Phase 6)**: Implemented Settings & Preferences ✅
  - **AppSettings model**: Created Models/AppSettings.swift with @AppStorage persistence
    - Hotkey configuration (key code, recording mode)
    - General settings (launch at login, show overlay)
    - Recognition settings (language, on-device preference)
    - Insertion method preference (auto/direct/clipboard/typing)
  - **SettingsView**: Created 5-tab interface in UI/SettingsView.swift
    - General: launch at login, show overlay toggle
    - Hotkey: key code display and change button, recording mode picker
    - Recognition: language picker with 30+ languages, on-device toggle
    - Insertion: method selection with radio buttons, explanation text
    - About: app info, version, links
  - **Integration with managers**:
    - AppDelegate reads and applies all settings on startup
    - Hotkey key code and recording mode synced from settings
    - Speech recognizer language configurable via setLanguage()
    - Text insertion respects method preference
    - Overlay visibility controlled by settings
  - **Settings window**: Opens from menu bar, floating window, persists state
  - **RecordingMode enum**: Consolidated into AppSettings (removed duplicate from HotkeyManager)
  - **Toggle mode support**: Hotkey can now toggle recording on/off instead of just hold-to-record
  - All settings automatically persist via UserDefaults/@AppStorage
  - **Known limitations**:
    - Launch at login not yet implemented (requires ServiceManagement framework)
    - Hotkey recorder UI not yet functional (button exists but doesn't capture keys)

- **2025-11-06 (Phase 5 Post-Implementation)**: Transcription Processing & Hotkey Improvements ✅
  - **Automatic punctuation enabled**: Set `addsPunctuation = true` on SFSpeechAudioBufferRecognitionRequest
  - **Filler word removal**: Created TranscriptionProcessor.swift utility
    - Removes common filler words: um, uh, er, ah, like, you know, I mean, sort of, kind of, basically
    - Cleans up spacing and fixes capitalization after periods
    - Applied automatically in AppDelegate before text insertion
  - **Switched from CGEvent tap to NSEvent monitors**: Better compatibility with system keys
    - Uses both `addLocalMonitorForEvents` and `addGlobalMonitorForEvents`
    - Monitors keyDown, keyUp, and flagsChanged events
    - Fn key sends flagsChanged events (not keyDown/keyUp)
    - Works both when app is focused and in background
  - **Changed default Fn key code**: 63 (not 179) - typical on modern Macs
  - **Added debug tools to menu bar**:
    - "Debug: Log All Keys" - Toggle to see all key presses with keyCodes
    - "Change Hotkey KeyCode..." - Dialog to customize trigger key
    - "Check Status" - Comprehensive diagnostic output
  - **Key discoveries**:
    - Fn key is keyCode 63 on most modern Macs
    - Fn key generates flagsChanged events, not keyDown/keyUp
    - NSEvent monitors more reliable than CGEvent tap for system keys
    - Speech framework's automatic punctuation works well with natural pauses
  - **Full workflow now functional**: Hold Fn → speak → release Fn → cleaned text inserted
  - Removed excessive logging from production builds

- **2025-11-06 (Phase 5)**: Implemented Menu Bar UI & Visual Feedback ✅
  - Created AppDelegate.swift as menu bar app controller
  - NSStatusItem with dynamic SF Symbol icons (mic.fill, mic.circle.fill, exclamationmark.triangle.fill)
  - Menu bar menu with dictation controls and app navigation
  - Created TranscriptionOverlayWindow for floating transcription display
  - TranscriptionOverlayView with SwiftUI for polished UI
  - TranscriptionOverlayController manages overlay lifecycle
  - Real-time transcription updates via Combine observer
  - Overlay positioning near mouse cursor with screen bounds checking
  - Created PermissionsView for dedicated permissions management window
  - Modified LocalDictationApp.swift to use NSApplicationDelegateAdaptor
  - Added verification script: scripts/verify_phase5.sh
  - **Key implementation details**:
    - Menu bar app (no dock icon, lives in status bar)
    - Overlay has `.floating` window level and `.stationary` collection behavior
    - Animated recording indicator with easeInOut repeating animation
    - Transcription observer watches speechManager.$transcriptionText
    - Hotkey callbacks trigger startRecording/stopRecording in AppDelegate
    - Full workflow: Fn key press → show overlay → record → transcribe → hide overlay → insert text
  - All 36 verification checks pass, ready for manual testing


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
    - ~~Fn key is keyCode 179 on MacBook Air~~ (Updated: typically 63 on modern Macs, see Phase 5 post-implementation)
    - Event tap must use `CFRunLoopGetMain()` not `CFRunLoopGetCurrent()`
    - UI updates from event callbacks must be dispatched to main thread
    - Accessibility permission requires re-grant after each rebuild during development
    - ~~CGEvent tap~~ (Later replaced with NSEvent monitors for better reliability)
  - All verification checks pass, UI indicator working

- **2025-11-06 (Phase 2)**: Removed iOS-specific AVAudioSession code that was incompatible with macOS
  - AudioEngineManager.swift: Removed `configureAudioSession()` and `resetAudioSession()`
  - SpeechRecognitionManager.swift: Removed AVAudioSession configuration calls
  - On macOS, AVAudioEngine works directly without session configuration

### Ready for Phase 6
Phase 5 is complete and verified. The app is now a functional menu bar application with visual feedback. Ready to proceed with settings and preferences.

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

## Phase 6: Settings & Preferences ✅ COMPLETE

**Goal**: Allow users to customize app behavior.

**Deliverable**: Fully functional settings window with all customization options.

### Completed Tasks
1. ✅ Created AppSettings model with @AppStorage:
   - Hotkey configuration (key code)
   - Recording mode (hold vs toggle)
   - Insertion mode preference (auto/direct/clipboard/typing)
   - Show overlay toggle
   - Language selection (30+ languages)
   - Launch at login (UI exists, implementation pending)
2. ✅ Created SettingsView with 5 tabs:
   - General: launch at login toggle, show overlay toggle
   - Hotkey: key code display, change button, recording mode picker
   - Recognition: language picker, on-device preference toggle
   - Insertion: method selection with radio buttons
   - About: version info, app description, links
3. ⚠️ Hotkey recorder UI (button exists but not yet functional - can use Debug menu instead)
4. ✅ Language picker with 30+ languages
5. ⚠️ Launch at login (toggle exists but not implemented - requires ServiceManagement framework)
6. ✅ All settings persist via UserDefaults/@AppStorage

### Integration Complete
- AppDelegate reads settings on startup
- Hotkey manager configured from settings
- Speech recognizer language configurable
- Text insertion respects method preference
- Overlay visibility controlled by settings
- Recording mode (hold vs toggle) fully functional

**Status**: Phase 6 complete. Settings window functional, all core settings working. Launch at login and interactive hotkey recorder deferred to Phase 7 or 8.

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
