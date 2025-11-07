# Check LocalDictation Crash Logs

Check all three crash log locations for the LocalDictation app to investigate crashes:

## 1. System Crash Reports (DiagnosticReports)
Check `~/Library/Logs/DiagnosticReports/` for LocalDictation crash reports (.ips files)
- These contain full stack traces and system information
- Look for files matching: `LocalDictation-*.ips`
- Use: `ls -lat ~/Library/Logs/DiagnosticReports/ | grep LocalDictation | head -5`

## 2. App Debug Logs
Check `~/Documents/LocalDictation/debug_logs/` for detailed debug output
- Contains timestamped debug messages from the app
- Shows method entry/exit, state changes, and error details
- Latest log is symlinked to `latest.log`
- Use: `ls -lat ~/Documents/LocalDictation/debug_logs/ | head -5`

## 3. Project Crash Logs
Check `/Users/will/Repos/local-transcription-service/crash_logs/` for saved crash logs
- Contains crash logs copied/saved during development
- Often in .rb format
- Use: `ls -lat /Users/will/Repos/local-transcription-service/crash_logs/ | head -5`

## Analysis Steps:
1. First check the most recent files in each location
2. Look for crash timestamps that match
3. Read the system crash report for the stack trace
4. Read the debug log for context leading up to the crash
5. Check if there's a corresponding saved crash log in the project folder

## Common Crash Patterns:
- **EXC_BAD_ACCESS in objc_release**: Autorelease pool zombie object issue
- **TCC_CRASHING_DUE_TO_PRIVACY_VIOLATION**: Permission check called too early
- **Signal 11 (SIGSEGV)**: Memory access violation

Remember to check all three locations for a complete picture of what happened!