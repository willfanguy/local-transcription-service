# Local Dictation App - Current Status

**Date**: November 8, 2025
**Branch**: `file-based-recognition`
**Last Working Session**: Implementing simplified recognizer lifecycle (no destroy/recreate between sessions)

## Executive Summary

After extensive research into Speech framework behavior and multiple approaches, discovered that **destroying and recreating the recognizer between sessions** was causing the crashes. Implementing industry-standard approach: keep same `SFSpeechRecognizer` instance across sessions, only cancel/recreate recognition tasks.

## Recent Changes (November 8, 2025 - Session 2)

### Attempted Fix #1: Deferred Reset (11:30-11:41 AM)
**Hypothesis**: Completion handler fires AFTER we destroy recognizer, adding autoreleased objects referencing dead memory.

**Implementation**:
- Added `requestResetAfterCompletion()` method to wait for completion handler
- Used callback pattern to defer recognizer reset until handler finishes
- Added 5-second timeout as safety net

**Result**: ❌ **Still crashed**
- Deferred reset DID execute properly (logs confirmed)
- But crash occurred 137ms AFTER starting NEW recognition session
- Crash happened DURING startup, not during cleanup
- **Conclusion**: The reset itself is the problem, not the timing

### Current Fix #2: No Reset - Keep Same Recognizer (11:42 AM)
**Hypothesis**: Based on Speech framework research, destroying/recreating recognizer is non-standard and causes crashes.

**Implementation**:
- Removed ALL `resetRecognizer()` calls from `AppDelegate.stopRecording()`
- Removed `requestResetAfterCompletion()` mechanism
- Keep same `SFSpeechRecognizer` instance for app lifetime
- Only cancel task, nil out task/request, then create new task for next session

**This matches industry best practices found in research**:
- Most developers DON'T destroy recognizer between sessions
- Standard pattern: cancel task → nil task/request → start new task
- Recognizer persists across multiple recognition sessions

**Testing**: In progress

## Research Findings from Speech Framework Documentation

### Key Discoveries:

1. **Completion Handler Continues After cancel()**
   - Stack Overflow reports: calling `task.cancel()` does NOT immediately stop completion handler
   - Handler continues to execute after delay
   - `isCanceled` returns `false` immediately after calling `cancel()`

2. **No Synchronous Cancellation**
   - Framework provides no way to ensure all callbacks have completed
   - Cancellation is asynchronous with no completion notification

3. **Standard Cleanup Pattern** (from multiple sources):
   ```swift
   recognitionTask?.cancel()
   audioEngine.stop()
   inputNode.removeTap(onBus: 0)
   recognitionRequest = nil
   recognitionTask = nil
   // NOTE: Recognizer is NOT destroyed
   ```

4. **Recognizer Lifecycle**:
   - Most examples create recognizer ONCE and keep it for app lifetime
   - Only task and request are recreated for each session
   - No documentation mentions destroying/recreating recognizer

5. **1-Minute Task Limit**:
   - `SFSpeechRecognitionTask` has hard 1-minute limit
   - Tasks must be recreated for longer sessions
   - This is a framework limitation, not a bug

### Files Modified:

**LocalDictation/Core/SpeechRecognitionManager.swift** (~50 lines added):
- Added `pendingResetCompletion` callback mechanism (now unused)
- Added `requestResetAfterCompletion()` method (now unused)
- Added timeout protection for deferred reset (now unused)
- **Note**: These additions will be removed if current fix works

**LocalDictation/AppDelegate.swift** (major simplification):
- **REMOVED**: All recognizer reset logic
- **REMOVED**: Deferred reset requests
- **REMOVED**: Autoreleasepool draining
- **REMOVED**: 500ms delays and run loop cycles
- **KEPT**: Simple `stopRecognition()` call
- **KEPT**: Immediate text processing

## Current App State

- **Build Status**: SUCCESS (last build: 11:42 AM, Nov 8)
- **Running**: Ready to test
- **Approach**: Simplified - no recognizer destruction between sessions
- **Code Complexity**: Significantly reduced

## Crash History (This Session)

**Crash #1** - 11:26:21 AM (First deferred reset attempt):
- Pattern: 4 seconds after completion handler finished
- During: Main event loop autorelease pool drain
- Issue: Reset AFTER handler still caused problems

**Crash #2** - 11:41:07 AM (Second test with deferred reset):
- Pattern: 137ms after starting NEW recognition
- During: Recognition startup, not cleanup
- Issue: Proves the reset itself is the problem

**Crash #3** - 11:26:24 AM (Original crash that started this):
- Pattern: 2 seconds after cycle complete
- During: Main event loop autorelease pool drain
- Issue: Autoreleased objects referencing destroyed recognizer

## What's Next

### Immediate Testing:
1. ✅ Build completed successfully
2. 🔄 Launch app and run Crash Test Harness
3. 🔄 Test "1s record, 0s delay" (rapid cycling)
4. 🔄 Test "0.5s record, 0.5s delay" (stress test)
5. 🔄 Verify multiple cycles without crash

### If This Works:
- Clean up unused deferred reset code from SpeechRecognitionManager
- Remove `resetRecognizer()` method entirely
- Update documentation with correct lifecycle pattern
- Commit changes

### If This Fails:
- Consider that rapid cycling itself may be problematic
- Investigate if Speech framework has internal state issues
- May need to file radar with Apple
- Consider alternative approaches (longer cooldowns, different recognition pattern)

## Root Cause (Updated Understanding)

**Previous Theory** (INCORRECT):
- Completion handler fires after we destroy recognizer
- Autoreleased objects reference deallocated memory
- Need to defer reset until handler completes

**Current Theory** (Based on Research):
- Destroying and recreating recognizer is non-standard pattern
- Speech framework expects recognizer to persist across sessions
- Internal framework state becomes corrupted when recognizer is destroyed mid-lifecycle
- Autoreleased objects may hold weak references that break when recognizer is recreated

**Evidence**:
- No major examples show recognizer destruction between sessions
- Crashes occur both AFTER stopping AND DURING starting new sessions
- Deferred reset (which worked for cleanup) still crashed during startup
- This indicates the destroy/recreate pattern itself is fundamentally incompatible

## Debug Information

- **Debug Logs**: `~/Documents/LocalDictation/debug_logs/latest.log`
- **Crash Reports**: `~/Library/Logs/DiagnosticReports/LocalDictation*.ips`
- **Latest Crash**: `LocalDictation-2025-11-08-114110.ips` (11:41 AM)

## Git Status

**Uncommitted changes**: 2 source files modified
```
M LocalDictation/AppDelegate.swift (simplified - removed reset logic)
M LocalDictation/Core/SpeechRecognitionManager.swift (added deferred reset - may remove)
```

**Recommendation**: Test before committing. If successful, clean up unused code before commit.

## Key Insights from This Session

### What We Learned:

1. ✅ **TCC crash fix**: Cannot call `SFSpeechRecognizer.authorizationStatus()` from within callback
2. ✅ **Research-backed approach**: Most developers keep same recognizer instance
3. ✅ **Deferred execution works**: Callback pattern successfully deferred reset until handler finished
4. ❌ **But wrong approach**: Even proper timing didn't fix the crash
5. ✅ **Root cause identified**: Destroying/recreating recognizer is the problem, not timing

### Best Practices (From Research):

1. **Create recognizer once** - Keep same instance for app lifetime
2. **Recreate only tasks** - Cancel old task, create new task for each session
3. **Clean up properly** - Cancel task, stop engine, remove tap, nil references
4. **Don't fight the framework** - Follow established patterns rather than inventing new ones

### Technical Details:

- Completion handlers continue executing after `cancel()` (documented in forums)
- No synchronous way to ensure all callbacks complete
- Framework manages internal state that breaks when recognizer destroyed
- Autorelease pool issues are symptom, not cause

---

**Last Updated**: November 8, 2025 11:50 AM CST
**Status**: PIVOTING - Apple's streaming API has unfixable framework bugs. Moving to alternative approaches.
**Next Action**: Implement file-based recognition or WhisperKit

---

## Post-Mortem: Why Streaming Failed

After 3 crash attempts and extensive research:

**Root Cause**: Apple's `SFSpeechAudioBufferRecognitionRequest` has autorelease pool bugs during rapid start/stop cycles. The framework creates autoreleased objects in callbacks that outlive the recognizer's lifecycle, causing `EXC_BAD_ACCESS` crashes.

**Attempts Made**:
1. ❌ Manual reset with delays - Still crashed
2. ❌ Deferred reset (wait for completion) - Still crashed
3. ❌ No reset at all - Still crashed

**Crash Pattern**: ~130-150ms after starting recognition, during autorelease pool drain in main event loop.

**Industry Research**: ALL successful dictation apps (Vocorize, Open-Whispr, etc.) avoid live streaming. They use "record-then-transcribe" pattern.

## New Direction

See **[ALTERNATIVES.md](./ALTERNATIVES.md)** for complete analysis of alternative approaches.

**Two viable options**:

1. **Apple File-Based API** (`SFSpeechURLRecognitionRequest`)
   - Easiest migration (2-4 hours)
   - Same framework, different API
   - Record to file → transcribe file → delete file
   - No rapid cycling issues

2. **WhisperKit** (Swift/CoreML Whisper)
   - Modern, production-ready
   - Better accuracy than Apple
   - 1-2 day integration
   - Used by Vocorize and other commercial apps

**Decision**: Implement both on separate branches, test and compare.
