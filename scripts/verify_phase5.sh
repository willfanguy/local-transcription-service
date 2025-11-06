#!/bin/bash

# Phase 5 Verification Script: Menu Bar UI & Visual Feedback
# Verifies that menu bar app structure, overlay, and visual feedback are properly implemented

set -e  # Exit on any error

echo "======================================"
echo "Phase 5 Verification: Menu Bar UI & Visual Feedback"
echo "======================================"
echo ""

# Change to project root
cd "$(dirname "$0")/.."

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Helper function to check test result
check_test() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $1"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}: $1"
        ((TESTS_FAILED++))
    fi
}

echo "1. Checking AppDelegate.swift exists and contains NSStatusItem..."
grep -q "NSStatusItem" LocalDictation/AppDelegate.swift
check_test "AppDelegate has NSStatusItem"

echo ""
echo "2. Checking menu bar icon state management..."
grep -q "RecordingState" LocalDictation/AppDelegate.swift
check_test "RecordingState enum defined"
grep -q "updateMenuBarIcon" LocalDictation/AppDelegate.swift
check_test "updateMenuBarIcon method exists"

echo ""
echo "3. Checking menu bar menu items..."
grep -q '"Start Dictation"' LocalDictation/AppDelegate.swift
check_test "Start Dictation menu item"
grep -q '"Settings..."' LocalDictation/AppDelegate.swift
check_test "Settings menu item"
grep -q '"Permissions..."' LocalDictation/AppDelegate.swift
check_test "Permissions menu item"
grep -q '"Quit"' LocalDictation/AppDelegate.swift
check_test "Quit menu item"

echo ""
echo "4. Checking TranscriptionOverlay implementation..."
[ -f "LocalDictation/UI/TranscriptionOverlay.swift" ]
check_test "TranscriptionOverlay.swift exists"
grep -q "TranscriptionOverlayWindow" LocalDictation/UI/TranscriptionOverlay.swift
check_test "TranscriptionOverlayWindow class defined"
grep -q "TranscriptionOverlayView" LocalDictation/UI/TranscriptionOverlay.swift
check_test "TranscriptionOverlayView defined"
grep -q "TranscriptionOverlayController" LocalDictation/UI/TranscriptionOverlay.swift
check_test "TranscriptionOverlayController class defined"

echo ""
echo "5. Checking overlay integration in AppDelegate..."
grep -q "TranscriptionOverlayController" LocalDictation/AppDelegate.swift
check_test "AppDelegate has overlay controller"
grep -q "overlayController.show()" LocalDictation/AppDelegate.swift
check_test "Overlay show() called on recording start"
grep -q "overlayController.hide()" LocalDictation/AppDelegate.swift
check_test "Overlay hide() called on recording stop"

echo ""
echo "6. Checking real-time transcription updates..."
grep -q "transcriptionObserver" LocalDictation/AppDelegate.swift
check_test "Transcription observer defined"
grep -q "overlayController.updateText" LocalDictation/AppDelegate.swift
check_test "Overlay text updates from speech manager"

echo ""
echo "7. Checking visual feedback elements..."
grep -q "mic.fill" LocalDictation/AppDelegate.swift
check_test "Idle microphone icon"
grep -q "mic.circle.fill" LocalDictation/AppDelegate.swift
check_test "Recording microphone icon"
grep -q "exclamationmark.triangle.fill" LocalDictation/AppDelegate.swift
check_test "Error icon"

echo ""
echo "8. Checking overlay visual elements..."
grep -q "Circle()" LocalDictation/UI/TranscriptionOverlay.swift
check_test "Recording indicator dot"
grep -q "Listening..." LocalDictation/UI/TranscriptionOverlay.swift
check_test "Listening status text"
grep -q "ScrollView" LocalDictation/UI/TranscriptionOverlay.swift
check_test "Scrollable transcription view"

echo ""
echo "9. Checking overlay positioning..."
grep -q "positionNearCursor" LocalDictation/UI/TranscriptionOverlay.swift
check_test "Overlay positions near cursor"
grep -q "NSEvent.mouseLocation" LocalDictation/UI/TranscriptionOverlay.swift
check_test "Uses mouse location for positioning"

echo ""
echo "10. Checking overlay appearance..."
grep -q "\.floating" LocalDictation/UI/TranscriptionOverlay.swift
check_test "Overlay has floating window level"
grep -q "\.opacity" LocalDictation/UI/TranscriptionOverlay.swift
check_test "Overlay has transparency"
grep -q "RoundedRectangle" LocalDictation/UI/TranscriptionOverlay.swift
check_test "Overlay has rounded corners"

echo ""
echo "11. Checking PermissionsView for Permissions menu..."
[ -f "LocalDictation/UI/PermissionsView.swift" ]
check_test "PermissionsView.swift exists"
grep -q "PermissionRow" LocalDictation/UI/PermissionsView.swift
check_test "PermissionRow component defined"

echo ""
echo "12. Checking hotkey integration..."
grep -q "hotkeyManager.onHotkeyPressed" LocalDictation/AppDelegate.swift
check_test "Hotkey pressed callback"
grep -q "hotkeyManager.onHotkeyReleased" LocalDictation/AppDelegate.swift
check_test "Hotkey released callback"
grep -q "startRecording()" LocalDictation/AppDelegate.swift
check_test "startRecording method"
grep -q "stopRecording()" LocalDictation/AppDelegate.swift
check_test "stopRecording method"

echo ""
echo "13. Checking text insertion integration..."
grep -q "TextInsertionManager" LocalDictation/AppDelegate.swift
check_test "TextInsertionManager integrated"
grep -q "insertTranscribedText" LocalDictation/AppDelegate.swift
check_test "insertTranscribedText method exists"

echo ""
echo "14. Building project..."
xcodebuild -scheme LocalDictation -configuration Debug build > /dev/null 2>&1
check_test "Project builds successfully"

echo ""
echo "======================================"
echo "Phase 5 Verification Results"
echo "======================================"
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ Phase 5 verification PASSED!${NC}"
    echo ""
    echo "Next Steps for Manual Testing:"
    echo "1. Run the app: open LocalDictation.xcodeproj, press Cmd+R"
    echo "2. Look for the microphone icon in the menu bar"
    echo "3. Click the icon to see the menu with Start/Stop, Settings, Permissions, Quit"
    echo "4. Click 'Permissions...' to check all three permissions"
    echo "5. With all permissions granted, press Fn key (or use menu)"
    echo "6. Verify the overlay window appears with 'Listening...'"
    echo "7. Speak and watch transcription appear in real-time in the overlay"
    echo "8. Release Fn key and verify overlay disappears"
    echo "9. Check that text is inserted into the active application"
    echo "10. Verify menu bar icon changes state (idle → recording → idle)"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Phase 5 verification FAILED${NC}"
    echo "Please fix the failing tests before proceeding."
    echo ""
    exit 1
fi
