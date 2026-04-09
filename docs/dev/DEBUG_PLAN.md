# Debug Plan for Local Dictation App Crash Issue

## Current Status
- **Branch**: `file-based-recognition`
- **Commit**: `82bd754`
- **Date**: 2025-11-07
- **Problem**: App crashes with `EXC_BAD_ACCESS` on second recording attempt

## Problem Summary

### Symptoms
1. First recording works perfectly
2. Second recording attempt crashes with `EXC_BAD_ACCESS`
3. Stack trace shows `CoreFoundation___forwarding___.cold.6` (zombie object)
4. Crash occurs during autorelease pool drain in main event loop
5. 20 different architectural approaches have failed to fix it

### Current Diagnosis (Low Confidence)
- **Theory**: Autoreleased objects from cancelled recognition task reference deallocated memory
- **Confidence**: 30% - missing concrete evidence
- **Alternative theories**:
  - Audio tap removal failure (40%)
  - Recognition task race condition (30%)
  - AVAudioEngine state issue (20%)
  - Apple framework bug (10%)

## Agreed Approach: Debug Properly First

Will chose to get real debugging data before implementing any fix. We need concrete evidence, not guesswork.

## Implementation Plan

### Phase 1: Create Autonomous Testing Infrastructure ✅ IN PROGRESS

#### 1.1 File-based Logging System (CURRENT TASK)
**Purpose**: Enable autonomous debugging without manual intervention

**Implementation**:
- Create `LocalDictation/Utilities/DebugLogger.swift`
  - Thread-safe file writing
  - Timestamped entries with microsecond precision
  - Object memory addresses
  - Thread IDs
  - Automatic log rotation
  - Write to `~/Documents/LocalDictation/debug_logs/`

#### 1.2 Enhanced SpeechRecognitionManager Logging
**File**: `LocalDictation/Core/SpeechRecognitionManager.swift`

**Add logging for**:
- Object lifecycle (init/deinit with memory addresses)
- Recognition task state changes
- Audio engine state before/after operations
- Tap installation/removal with error handling
- Completion handler timing
- Thread IDs for all operations

**Key points**:
- Wrap `removeTap(onBus: 0)` in do-catch
- Log if tap exists before removal
- Log engine running state
- Track recognition request lifecycle

#### 1.3 Enhanced AppDelegate Logging
**File**: `LocalDictation/AppDelegate.swift`

**Add logging for**:
- Start/stop recording timing
- Completion handler execution
- State transitions
- Memory pressure events
- Background/foreground transitions

#### 1.4 Crash Test Harness
**File**: `LocalDictation/Debug/CrashTestHarness.swift`

**Features**:
- Simple SwiftUI window with buttons
- Automated test sequences:
  - Rapid start/stop (10 times, no delay)
  - Short recordings (1 second each)
  - Medium recordings (5 seconds each)
  - Long recordings (30 seconds each)
  - Various delays between recordings (0, 100ms, 500ms, 1s, 3s)
- Progress indicator
- Live log viewer
- Export logs button
- Crash detection and logging

#### 1.5 Test Runner Script
**File**: `test_crash.sh`

**Functionality**:
```bash
#!/bin/bash
# Build debug version with special flags
# Run test harness
# Monitor for crashes
# Collect crash reports
# Package logs for analysis
```

### Phase 2: Manual Xcode Configuration (Will's Part)

#### 2.1 Enable Debugging Tools
1. **Edit Scheme → Run → Diagnostics**:
   - ✅ Zombie Objects
   - ✅ Malloc Stack (All Allocation and Free History)
   - ✅ Malloc Guard Edges
   - ✅ Guard Malloc

2. **Build Settings**:
   - Enable Address Sanitizer = YES
   - Debug Information Format = DWARF with dSYM

3. **Breakpoints**:
   - Add Exception Breakpoint (All Objective-C Exceptions)
   - Add Symbolic Breakpoint on `___forwarding___`

#### 2.2 Run Test Sequence
1. Grant permissions (Microphone, Speech, Accessibility)
2. Run app with debugger attached
3. Click "Run Automated Tests" in test harness
4. When crash occurs, save:
   - Console output → `crash_console.log`
   - Crash report → `crash_report.crash`
   - Debug navigator stack trace → screenshot

### Phase 3: Autonomous Analysis

#### 3.1 Log Analysis Script
**File**: `analyze_logs.py`

**Analysis**:
- Parse debug logs for patterns
- Identify object lifecycle issues
- Find timing correlations
- Detect thread race conditions
- Generate report

#### 3.2 Fix Implementation
Based on findings, implement targeted fix:
- If audio tap issue → Proper tap management
- If task race → Synchronization primitives
- If engine state → State machine implementation
- If framework bug → Workaround or alternative API

### Phase 4: Verification

#### 4.1 Automated Verification
- Run 100 recording cycles
- Various recording durations
- Monitor for crashes
- Check memory leaks

#### 4.2 Manual Verification
- Test with actual hotkey usage
- Test with various apps
- Test system sleep/wake
- Test with other audio apps

## File Structure

```
LocalDictation/
├── Debug/                      # NEW - Debug infrastructure
│   ├── CrashTestHarness.swift
│   └── TestSequences.swift
├── Utilities/
│   ├── DebugLogger.swift      # NEW - File-based logging
│   └── CrashReporter.swift    # NEW - Crash detection
├── Logs/                      # NEW - Local log storage
│   └── .gitignore (ignore log files)
```

## Progress Tracking

### Completed
- [x] Analyzed existing crash documentation
- [x] Reviewed 20 failed attempts
- [x] Identified weak evidence for root cause
- [x] Got Will's decision to debug properly
- [x] Created file-based logging system (`DebugLogger.swift`)
- [x] Added comprehensive logging to `SpeechRecognitionManager`
- [x] Added diagnostic logging to `AppDelegate`
- [x] Created crash test harness with GUI (`Debug/CrashTestHarness.swift`)
- [x] Created test runner script (`test_crash.sh`)
- [x] Documented testing procedure (`TESTING_PROCEDURE.md`)

### Ready for Will
- [ ] Will runs tests with test harness or Xcode debugging
- [ ] Will shares crash logs and debug output

### TODO After Getting Crash Data
- [ ] Analyze crash data
- [ ] Implement targeted fix based on findings
- [ ] Verify fix works
- [ ] Document solution

## Key Files to Track

1. **Modified files**:
   - `LocalDictation/Core/SpeechRecognitionManager.swift`
   - `LocalDictation/AppDelegate.swift`

2. **New files**:
   - `LocalDictation/Utilities/DebugLogger.swift`
   - `LocalDictation/Debug/CrashTestHarness.swift`
   - `LocalDictation/Debug/TestSequences.swift`
   - `test_crash.sh`
   - `analyze_logs.py`

## Commands for Quick Testing

```bash
# Build debug version
xcodebuild -scheme LocalDictation -configuration Debug

# Run with logging
./LocalDictation.app/Contents/MacOS/LocalDictation --debug-logging

# Check for crash reports
ls ~/Library/Logs/DiagnosticReports/LocalDictation*.crash

# View latest log
tail -f ~/Documents/LocalDictation/debug_logs/latest.log
```

## Context Reset Instructions

If we need to reset context:
1. Reference this file for current status
2. Check "Progress Tracking" section
3. Review "Key Files to Track" for what was modified
4. Continue from "In Progress" items
5. Use git diff to see uncommitted changes

## Notes for Will

**What you need to do**:
1. Once I finish the test harness, run it with Xcode debugging enabled
2. Grant permissions when prompted
3. Click "Run Automated Tests"
4. When it crashes, save the crash report to the repo
5. I can then analyze and iterate on fixes autonomously

**What I can do autonomously**:
- Add/modify logging
- Create test sequences
- Analyze log files
- Implement fixes based on crash data
- Run command-line tests

**What needs your help**:
- Running with Xcode debugger
- Granting permissions
- Copying crash reports
- Testing with actual hotkey usage

---
Last updated: 2025-11-07
Status: **READY FOR TESTING** - All debugging infrastructure complete. Waiting for Will to run tests and provide crash data.