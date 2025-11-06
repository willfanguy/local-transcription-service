# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Local Dictation App - A macOS menu bar application for system-wide voice dictation using Apple's native Speech framework. The app provides global hotkey-triggered dictation that transcribes speech in real-time and inserts text into any active application.

**Tech Stack**: Swift 5.9+, SwiftUI + AppKit, Speech framework (SFSpeechRecognizer), AVFoundation, Accessibility API, Carbon (for global hotkeys)

**Target**: macOS 13.0+ (Ventura)

## Architecture

### Core Components

The app is structured into distinct layers:

**Core/** - Core functionality managers:
- `SpeechRecognitionManager`: Handles SFSpeechRecognizer lifecycle, transcription, and real-time updates. Must handle the undocumented 1-minute continuous recognition limit.
- `AudioEngineManager`: Manages AVAudioEngine for microphone input, installs tap on bus 0, feeds audio buffers to speech recognizer
- `HotkeyManager`: Implements global keyboard monitoring via CGEvent.tapCreate. Requires Accessibility permissions. Handles both "hold to record" and "toggle" recording modes.
- `TextInsertionManager`: Uses Accessibility API (AXUIElement) to insert transcribed text into focused elements. Implements fallback chain: direct API → clipboard paste → simulated typing

**UI/** - User interface components:
- `MenuBarView`: Status item with dynamic icon states (idle/recording/error)
- `TranscriptionOverlay`: Floating semi-transparent window showing real-time transcription during recording
- `SettingsView`: Multi-tab configuration (General, Hotkey, Recognition, Insertion, About)
- `PermissionsView`: Guides users through microphone, speech recognition, and Accessibility permission requests

**Models/** - Data structures:
- `AppSettings`: User preferences using @AppStorage
- `TranscriptionSession`: Recording session state
- `HotkeyConfiguration`: Keyboard shortcut configuration

**Utilities/**:
- `PermissionsManager`: Centralized permission checking and requesting
- `AccessibilityHelper`: Wrappers around Accessibility API

### Key Implementation Patterns

**Speech Recognition Setup**:
- Always check `isAvailable` before creating recognition tasks
- Prefer `requiresOnDeviceRecognition = true` for privacy
- Set `shouldReportPartialResults = true` for real-time UI updates
- Handle the 1-minute recognition timeout with restart logic

**Audio Engine Configuration**:
- Use buffer size of 1024 for the input node tap
- Get recording format from `inputNode.outputFormat(forBus: 0)`
- Append buffers to `SFSpeechAudioBufferRecognitionRequest`

**Global Hotkey Detection**:
- Use CGEvent.tapCreate with `.cgSessionEventTap` and `.headInsertEventTap`
- Monitor `CGEventType.keyDown` events
- Default hotkey is Fn key (keyCode 63)
- Requires Accessibility permissions - check with `AXIsProcessTrusted()`

**Text Insertion Strategy** (in priority order):
1. Direct Accessibility API: `AXUIElementSetAttributeValue` with `kAXValueAttribute`
2. Clipboard paste: Set NSPasteboard, simulate Cmd+V, restore previous clipboard
3. Simulated typing: CGEvent.keyboardEvent for each character

## Development Commands

### Xcode Project
- Build: Cmd+B or `xcodebuild -scheme LocalDictation -configuration Debug`
- Run: Cmd+R (launches with debugger attached)
- Test: Cmd+U or `xcodebuild test -scheme LocalDictation`
- Clean: Cmd+Shift+K or `xcodebuild clean`

### Testing Single Components
When implementing/testing individual managers without full app context, create a test harness:
```swift
// In a temporary playground or test target
let manager = SpeechRecognitionManager()
manager.startRecognition()
// Test specific functionality
```

## Critical Requirements

### Permissions (Info.plist)
Must include:
- `NSMicrophoneUsageDescription`
- `NSSpeechRecognitionUsageDescription`

App requires three permission grants:
1. Microphone (AVFoundation)
2. Speech Recognition (Speech framework)
3. Accessibility (for global hotkeys and text insertion) - must be manually enabled in System Settings

### Entitlements
- Audio Input: Required
- App Sandbox: Disable temporarily for Accessibility API during development, required on for distribution

### Error Handling
Implement comprehensive `DictationError` enum covering:
- Permission denials (microphone, speech, accessibility)
- Recognizer unavailable
- Audio engine failures
- Recognition timeout (1-minute limit)
- Text insertion failures

Always show actionable error messages to users with "Open System Settings" buttons where applicable.

## Development Workflow

Development follows 8 sequential phases (see Development Plan.md):
1. Project Setup & Permissions
2. Speech Recognition Core
3. Global Hotkey Detection
4. Text Insertion via Accessibility API
5. Menu Bar UI & Visual Feedback
6. Settings & Preferences
7. Error Handling & Edge Cases
8. Testing & Polish

Each phase builds on the previous. Don't skip ahead - complete deliverables in order.

## Testing Requirements

Test text insertion across diverse applications:
- Native apps: TextEdit, Notes, Mail, Messages
- Web browsers: Safari, Chrome (form inputs)
- Chat apps: Slack, Discord
- Development: VS Code, Xcode
- Terminal (limited support expected)

Test edge cases:
- Very long recordings (>1 minute triggers timeout handling)
- Very short recordings (<1 second)
- Permission revoked mid-session
- Rapid start/stop cycles
- Background noise
- Multiple languages

## Known Limitations

1. SFSpeechRecognizer has undocumented 1-minute continuous recognition limit - implement restart logic
2. Accessibility API permission required for both global hotkeys AND text insertion
3. On-device recognition not available for all languages
4. Some apps may not support Accessibility API text insertion (fallback to clipboard)

## Important Notes

- Default hotkey is Fn key (keyCode 63), customizable in settings
- Support both "hold to record" and "toggle" recording modes
- Always try to use on-device recognition when available (`supportsOnDeviceRecognition`)
- Menu bar icon must provide clear visual feedback for recording state
- Log which text insertion method was used for debugging
- All settings must persist via UserDefaults/@AppStorage
