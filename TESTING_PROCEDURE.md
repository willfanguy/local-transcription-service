# Testing Procedure for Crash Debugging

## Overview

I've set up comprehensive debugging infrastructure to help us identify the root cause of the second-recording crash. This document explains how to use it.

## What I've Added

1. **File-based logging system** (`DebugLogger.swift`)
   - Logs to `~/Documents/LocalDictation/debug_logs/`
   - Thread-safe with microsecond timestamps
   - Tracks object lifecycles and memory addresses
   - Automatically rotates logs at 10MB

2. **Enhanced logging** in:
   - `SpeechRecognitionManager.swift` - Detailed lifecycle and state tracking
   - `AppDelegate.swift` - Recording timing and state transitions

3. **Crash Test Harness** (`Debug/CrashTestHarness.swift`)
   - GUI for running automated test sequences
   - Multiple test scenarios (rapid, short, medium, stress)
   - Real-time log viewer
   - Export functionality

4. **Test runner script** (`test_crash.sh`)
   - Builds with debugging flags enabled
   - Sets environment variables for zombie detection
   - Monitors for crashes automatically

## Quick Start Testing

### Method 1: Using the GUI Test Harness (Easiest)

1. **Build and run the app normally:**
   ```bash
   open LocalDictation.xcodeproj
   # Press Cmd+R to run
   ```

2. **Grant permissions when prompted:**
   - Microphone
   - Speech Recognition
   - Accessibility (System Settings → Privacy & Security → Accessibility)

3. **Open test harness:**
   - Click menu bar icon → "Debug: Crash Test Harness..."

4. **Run tests:**
   - Select "Rapid Start/Stop" (most likely to trigger crash)
   - Click "Run Test"
   - Watch the log output

5. **If it crashes:**
   - The logs are automatically saved to `~/Documents/LocalDictation/debug_logs/`
   - Copy crash report from `~/Library/Logs/DiagnosticReports/LocalDictation*.crash`
   - Save both to the repo for analysis

### Method 2: Using Xcode with Debugging (Most Detailed)

1. **Configure Xcode scheme:**
   - Edit Scheme → Run → Diagnostics
   - Enable:
     - ✅ Zombie Objects
     - ✅ Malloc Stack (All Allocation and Free History)
     - ✅ Malloc Guard Edges
     - ✅ Address Sanitizer (Build Settings)

2. **Add breakpoints:**
   - Exception Breakpoint (Breakpoints navigator → + → Exception Breakpoint)
   - Symbolic Breakpoint on `___forwarding___`

3. **Run with debugger:**
   - Press Cmd+R
   - Use test harness or manually trigger recordings
   - When crash occurs, Xcode will stop at the exact line

4. **Save debugging info:**
   - Screenshot the stack trace
   - Copy console output to a file
   - Note which object is the zombie

### Method 3: Using the Test Script (Automated)

1. **Run the test script:**
   ```bash
   cd /Users/will/Repos/local-transcription-service
   ./test_crash.sh
   ```

2. **Follow the prompts:**
   - Grant permissions if needed
   - Open test harness when instructed
   - Run the test sequence

3. **Script automatically:**
   - Builds with debug flags
   - Monitors for crashes
   - Copies crash logs
   - Analyzes results

## What I Need From You

### First Run (One-Time Setup)

1. **Run the app once** with any method above
2. **Grant all permissions** when prompted
3. **Run a test sequence** (Rapid Start/Stop is best)
4. **When it crashes**, save:
   - The debug log: `~/Documents/LocalDictation/debug_logs/latest.log`
   - The crash report: `~/Library/Logs/DiagnosticReports/LocalDictation*.crash`
   - Console output if using Xcode

### What to Look For

The debug logs will show:

- **Object lifecycles** with memory addresses
- **Timing between operations** (crucial for race conditions)
- **Thread IDs** (to identify threading issues)
- **State transitions** (to see order of operations)
- **Critical events** marked with "===========" separators

Key markers to watch for:
- `START_RECORDING_CALLED` - When recording starts
- `STOP_RECORDING_CALLED` - When recording stops
- `CRITICAL_SECOND_RECORDING_ATTEMPT` - The dangerous second recording
- `ERROR` or `WARNING` - Problems detected
- `🔴` - Critical operation that might crash

## After the Crash

Once you provide the crash log and debug output, I can:

1. **Identify the exact object** that's being deallocated
2. **Trace its lifecycle** through the logs
3. **Find the timing issue** causing the crash
4. **Implement a targeted fix** based on real data

## Autonomous Testing

After the initial crash data, I can iterate on fixes by:

1. Analyzing the log files you provide
2. Implementing fixes based on the findings
3. You running the test harness again
4. Repeating until the crash is resolved

## Files to Share

After a crash, add these files to the repo:

1. `~/Documents/LocalDictation/debug_logs/debug_*.log` (latest one)
2. `~/Library/Logs/DiagnosticReports/LocalDictation*.crash` (newest)
3. Screenshot of Xcode debugger if using Method 2
4. Any console output

## Command Reference

```bash
# Build and test
./test_crash.sh

# View latest log
tail -f ~/Documents/LocalDictation/debug_logs/latest.log

# Find crash reports
ls -la ~/Library/Logs/DiagnosticReports/LocalDictation*.crash

# Clean build
xcodebuild clean -scheme LocalDictation

# Build with debugging
xcodebuild build -scheme LocalDictation -configuration Debug \
  ENABLE_ADDRESS_SANITIZER=YES \
  ENABLE_ZOMBIE_OBJECTS=YES
```

## Next Steps

1. Run Method 1 (GUI test harness) first - it's the easiest
2. If no crash, try Method 2 (Xcode debugging) for more detail
3. Share the crash data
4. I'll analyze and implement a fix
5. Test the fix
6. Repeat if needed

The key insight we need is **which specific object is being deallocated** and **when**. The enhanced logging will tell us exactly what's happening in the critical time window between recordings.

---

Ready to start whenever you are, Will. Just run the test harness and let's catch this bug!