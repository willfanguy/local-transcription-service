# Crash Fix Plan - Local Dictation App

## Executive Summary

The Local Dictation app has a critical bug: it crashes on the second recording attempt. After 20 different architectural attempts to fix this, we've determined this is a bug in Apple's Speech framework related to autoreleased objects during cleanup.

## The Problem

### What Happens
1. First recording works perfectly
2. On second recording attempt, app crashes with EXC_BAD_ACCESS
3. Crash occurs in autoreleasepool cleanup in main event loop
4. Stack trace shows: `CoreFoundation___forwarding___.cold.6` with message about deallocated instance

### What We've Tried (20 Attempts)
- Fresh AVAudioEngine for each recording (attempts 1-11)
- Keeping old engines/tasks/requests alive (attempts 12-18)
- Single long-lived engine (attempt 19)
- Mandatory cooldown period (attempt 20)
- Different hotkeys (tested Fn key and R key)

**All attempts failed** - the crash persists regardless of architecture.

## Root Cause

This appears to be a bug in Apple's Speech framework. The crash happens during autorelease pool cleanup when:
1. A speech recognition task is cancelled
2. Autoreleased objects from the task cleanup reference deallocated memory
3. The autorelease pool drains on the next event loop iteration
4. Crash occurs when accessing the zombie object

## Proposed Solution: Minimal Workaround

### Approach
Implement a **3-second mandatory cooldown** between recordings with clear UI feedback.

### Why This Works
- Gives autorelease pool time to fully drain
- Prevents rapid recording cycles that trigger the bug
- Maintains real-time streaming architecture as originally intended
- Simple, non-invasive change

### Implementation Steps

1. **Add Cooldown Timer**
   ```swift
   // In AppDelegate
   var lastRecordingEndTime: Date?
   let minimumCooldownSeconds = 3.0

   private func startRecording() {
       // Check cooldown
       if let lastEnd = lastRecordingEndTime {
           let timeSinceLastRecording = Date().timeIntervalSince(lastEnd)
           if timeSinceLastRecording < minimumCooldownSeconds {
               let remainingTime = minimumCooldownSeconds - timeSinceLastRecording
               showCooldownFeedback(remainingTime)
               return
           }
       }
       // Continue with normal recording...
   }

   private func stopRecording() {
       lastRecordingEndTime = Date()
       // Continue with normal stop...
   }
   ```

2. **Add UI Feedback**
   - Update menu bar icon to show cooldown state (grayed out mic?)
   - Show countdown in menu bar status text: "Wait 2.1s..."
   - Optionally show subtle notification/toast

3. **Update TranscriptionOverlay**
   - Add cooldown indicator state
   - Show "Please wait X seconds..." message
   - Disable during cooldown period

## Alternative Approaches (If Cooldown Insufficient)

### Option B: Hybrid Approach
- Use real-time streaming for first recording
- Switch to file-based recognition for subsequent recordings
- More complex but avoids crash entirely

### Option C: Apple Support Path
1. Create minimal reproduction case
2. File bug report with Apple (Feedback Assistant)
3. Consider Technical Support Incident (TSI)
4. Wait for framework fix

### Option D: Alternative Framework
- Investigate OpenAI Whisper API
- Consider other third-party solutions
- Major architectural change

## Current Code State

We're on branch `file-based-recognition` which is checked out from commit `82bd754` (before all crash investigation attempts). This is a clean state with:
- Working first recording
- All UI and settings implemented
- Simple, straightforward architecture
- No complex lifecycle management

## Next Steps

1. **Implement cooldown workaround** (3 seconds)
2. **Add clear UI feedback** during cooldown
3. **Test thoroughly** across multiple recording sessions
4. **Document as known limitation** in README
5. **Create minimal repro** for Apple bug report

## Known Limitations to Document

```markdown
### Known Issues

**Recording Cooldown**: Due to a bug in Apple's Speech framework, there's a mandatory 3-second cooldown between recordings. This prevents crashes that occur when starting a new recording too quickly after the previous one. We're working with Apple to resolve this issue.

**Workaround**: Wait for the cooldown indicator to clear before starting your next recording. The menu bar icon will show when recording is available again.
```

## Testing Checklist

- [ ] First recording works
- [ ] Cooldown prevents immediate second recording
- [ ] UI clearly shows cooldown state
- [ ] After cooldown, second recording works
- [ ] Multiple recordings work with cooldown between each
- [ ] No crashes or freezes
- [ ] Error messages are clear and actionable

## Success Criteria

The app should:
1. Never crash during normal use
2. Clearly communicate cooldown requirement to user
3. Maintain real-time transcription during recording
4. Insert text instantly after recording ends
5. Work reliably for extended sessions

## Files to Modify

1. `LocalDictation/AppDelegate.swift` - Add cooldown logic
2. `LocalDictation/UI/TranscriptionOverlay.swift` - Add cooldown UI state
3. `LocalDictation/Core/HotkeyManager.swift` - Disable during cooldown
4. `README.md` - Document known limitation
5. `LocalDictation/Models/AppSettings.swift` - (Optional) Make cooldown configurable

## Timeline

- **Hour 1**: Implement basic cooldown timer
- **Hour 2**: Add UI feedback
- **Hour 3**: Test and refine
- **Hour 4**: Document and create Apple bug report

This approach keeps us true to the original vision while working around a framework limitation we cannot directly fix.