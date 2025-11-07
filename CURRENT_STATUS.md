# Local Dictation App - Current Status
**Date**: November 7, 2025
**Branch**: `file-based-recognition`
**Last Working Session**: Fixing multiple crash issues

## Executive Summary

The Local Dictation app has been experiencing THREE different types of crashes:

1. **Speech Framework Crash** - Autorelease pool zombie object crash when starting second recording
2. **TCC Privacy Violation Crash #1** - When test harness tries to record without permissions
3. **TCC Privacy Violation Crash #2** - When app checks speech permissions on startup

All three have been addressed with fixes implemented.

## Crash Issues and Fixes

### 1. Speech Framework Crash (Original Issue)
**Symptoms**:
- App crashes with `EXC_BAD_ACCESS` when starting second recording
- Happens when recordings are started too quickly in succession
- Crash occurs during autorelease pool cleanup

**Root Cause**:
- Speech framework objects not properly released between recordings
- Autorelease pool tries to release already-deallocated objects

**Fix Applied**:
```swift
// AppDelegate.swift - Line 43
private let minimumCooldownSeconds = 5.0  // Increased from 3.0

// Added autoreleasepool blocks for aggressive cleanup
autoreleasepool {
    speechManager.stopRecognition()
}

// Visual feedback during cooldown
showCooldownFeedback(remainingTime: remainingTime)
```

### 2. TCC Privacy Crash - Test Harness
**Symptoms**:
- Crash when test harness tries to start recording
- `__TCC_CRASHING_DUE_TO_PRIVACY_VIOLATION__`

**Root Cause**:
- Test harness attempting to access microphone/speech without checking permissions

**Fix Applied**:
```swift
// CrashTestHarness.swift - Line 200-213
guard permissionsManager.allPermissionsGranted else {
    logMessages.append("❌ ERROR: Missing permissions!")
    // Show clear error message instead of attempting to record
    return
}
```

### 3. TCC Privacy Crash - Startup Permission Check
**Symptoms**:
- App crashes when user tries to grant permissions in System Settings
- Crash occurs immediately after app launch when checking permissions

**Root Cause**:
- `SFSpeechRecognizer.authorizationStatus()` called too early on startup
- TCC system not ready to handle permission check

**Fix Applied**:
```swift
// PermissionsManager.swift - Line 23-26
private init() {
    // Don't check permissions immediately to avoid TCC crashes
    // Permissions will be checked when needed
}

// AppDelegate.swift - Line 70-76
// Delay permission check to avoid TCC crash
DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
    // Only check microphone and accessibility first
    self?.permissionsManager.checkMicrophonePermission()
    self?.permissionsManager.checkAccessibilityPermission()
}
```

## Files Modified

1. **LocalDictation/AppDelegate.swift**
   - Added 5-second cooldown timer
   - Added autoreleasepool cleanup
   - Added cooldown UI feedback
   - Deferred permission checking on startup
   - Made recording methods public for test harness

2. **LocalDictation/Core/SpeechRecognitionManager.swift**
   - Added autoreleasepool around cleanup
   - Enhanced logging for debugging

3. **LocalDictation/Debug/CrashTestHarness.swift**
   - Added permission check before running tests
   - Fixed button style compatibility
   - Fixed AppDelegate reference using shared instance

4. **LocalDictation/Utilities/PermissionsManager.swift**
   - Removed automatic permission check in init()
   - Made permission checking more defensive

5. **LocalDictation/Utilities/DebugLogger.swift**
   - Added comprehensive debug logging system

## Permissions Reset

All permissions have been reset using:
```bash
tccutil reset All com.yourname.LocalDictation
tccutil reset Microphone com.yourname.LocalDictation
tccutil reset SpeechRecognition com.yourname.LocalDictation
tccutil reset Accessibility com.yourname.LocalDictation
```

## Current App State

- **Build Status**: SUCCESS (last build 13:42:54)
- **Permissions**: RESET (needs fresh grant)
- **App Location**: `/Users/will/Repos/local-transcription-service/build/Debug/LocalDictation.app`
- **Cooldown Timer**: 5 seconds
- **Debug Logging**: Enabled

## What's Next

### Immediate Steps:

1. **Clean Build & Run**:
```bash
# Clean build folder
rm -rf build/
xcodebuild clean -project LocalDictation.xcodeproj

# Build fresh
xcodebuild build -project LocalDictation.xcodeproj -configuration Debug

# Run the app
./build/Debug/LocalDictation.app/Contents/MacOS/LocalDictation
```

2. **Grant Permissions Carefully**:
   - Run the app first
   - Wait a few seconds for it to fully initialize
   - Click menu bar icon → "Open Permissions"
   - Grant permissions ONE AT A TIME:
     1. First: Microphone
     2. Second: Accessibility
     3. Last: Speech Recognition (only when needed for recording)

3. **Test Recording**:
   - Try manual recording with Fn key or menu
   - Verify 5-second cooldown works
   - Check that cooldown prevents crash

4. **Test Harness** (after permissions granted):
   - Click menu bar → "Debug: Crash Test Harness..."
   - Should show permission check first
   - Run "Rapid Start/Stop" test

## Known Issues

1. **Speech Recognition Permission Check**:
   - MUST NOT be checked on app startup
   - Only check when user actually tries to record
   - System Settings may still crash app if user tries to toggle it

2. **Cooldown Required**:
   - 5-second mandatory cooldown between recordings
   - This is a workaround for Apple Speech framework bug
   - Shows countdown in menu bar

## Debug Information

- **Debug Logs**: `~/Documents/LocalDictation/debug_logs/`
- **Crash Reports**: `~/Library/Logs/DiagnosticReports/LocalDictation*.crash`
- **Project Crash Logs**: `/Users/will/Repos/local-transcription-service/crash_logs/`

## Testing Checklist

- [ ] App launches without crash
- [ ] Can grant Microphone permission without crash
- [ ] Can grant Accessibility permission without crash
- [ ] Can record with Fn key (after permissions)
- [ ] 5-second cooldown prevents rapid recording
- [ ] Test harness checks permissions before running
- [ ] No crash on second recording with cooldown

## Important Notes

1. **DO NOT** check Speech Recognition permission on startup
2. **ALWAYS** wait for cooldown between recordings
3. **GRANT** permissions one at a time, slowly
4. **TEST** with manual recording before using test harness

## Contact for Issues

File bug reports at: https://github.com/anthropics/claude-code/issues

---
Last Updated: November 7, 2025, 13:47
Status: Ready for clean build and test with permission fixes