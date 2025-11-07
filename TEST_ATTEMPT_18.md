# Testing Instructions for Attempt 18

## What Changed
We've implemented a comprehensive fix (attempt 18) for the EXC_BAD_ACCESS crash that includes:

1. **Engine lifecycle improvements**:
   - Engine is now stopped cleanly before moving to history
   - Engine is prepared and started BEFORE installing tap (more stable)

2. **Autoreleasepool management**:
   - Task/request cleanup wrapped in autoreleasepool to immediately drain objects
   - Small delay added after cleanup to ensure pool is fully drained

3. **Existing safeguards** (from attempts 15-17):
   - Engine history keeps old engines alive for 2 recording cycles
   - Previous task AND request kept alive until next recording
   - No tap removal in cleanup flow

## Testing Steps

### 1. Launch the App Through Xcode (RECOMMENDED)
```bash
# Open Xcode
open /Users/will/Repos/local-transcription-service/LocalDictation.xcodeproj

# In Xcode:
# 1. Select LocalDictation scheme (should be selected)
# 2. Press Cmd+R to run with debugger attached
# 3. Console output will appear in bottom panel
```

### Alternative: Command Line Launch
```bash
# Navigate to the built app
cd /Users/will/Library/Developer/Xcode/DerivedData/LocalDictation-*/Build/Products/Debug/
./LocalDictation.app/Contents/MacOS/LocalDictation
```

### 2. Grant Permissions (if needed)
- Grant Accessibility permission if prompted
- Microphone and Speech Recognition should auto-grant on first use

### 3. Test Recording Sequence

**CRITICAL TEST**: The second recording is where the crash happens

1. **First Recording** (should work):
   - Hold Fn key (or configured hotkey)
   - Speak for 2-3 seconds
   - Release Fn key
   - Verify text is inserted

2. **Wait 2-3 seconds** (let everything settle)

3. **Second Recording** (THIS IS THE CRASH POINT):
   - Hold Fn key again
   - Watch console for any errors
   - Speak for 2-3 seconds
   - Release Fn key
   - **SUCCESS**: Text is inserted without crash
   - **FAILURE**: App crashes or freezes

4. **Third Recording** (if second succeeded):
   - Repeat to ensure stability

### 4. Console Output to Watch For

**Good signs**:
```
Releasing previous recording's task and request (in autoreleasepool)
Audio engine prepared and started
Audio tap installed on running engine
Recognition started successfully
```

**Bad signs**:
- EXC_BAD_ACCESS crash
- "Segmentation fault"
- App freezes/hangs
- Overlay stuck on screen

### 5. If It Crashes

1. Note the exact crash location from debugger/console
2. Check if crash is still in autorelease pool or somewhere else
3. Save the crash log

## Expected Result

With attempt 18's comprehensive fixes, the app should:
- Successfully complete multiple recordings without crashing
- Show proper cleanup messages in console
- Maintain stable memory management across recording cycles

## If Attempt 18 Fails

We have several alternative approaches ready:
1. **Single long-lived engine**: Reuse the same engine with proper reset
2. **Mandatory cooldown**: Force 2-second delay between recordings
3. **File-based recognition**: Record to temp file, recognize from file
4. **Minimal test case**: Create isolated reproduction for Apple bug report

## Quick Debug Commands

```bash
# Run with malloc debugging
MallocScribble=1 MallocPreScribble=1 ./LocalDictation.app/Contents/MacOS/LocalDictation

# Run with zombie objects enabled
NSZombieEnabled=YES ./LocalDictation.app/Contents/MacOS/LocalDictation

# Run with guard malloc (very slow but catches all overruns)
DYLD_INSERT_LIBRARIES=/usr/lib/libgmalloc.dylib ./LocalDictation.app/Contents/MacOS/LocalDictation
```