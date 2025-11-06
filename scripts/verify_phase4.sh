#!/bin/bash

# Phase 4 Verification Script
# Tests text insertion via Accessibility API implementation

set -e

echo "=========================================="
echo "Phase 4: Text Insertion Verification"
echo "=========================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Track verification status
ALL_PASSED=true

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}: $2"
    else
        echo -e "${RED}❌ FAIL${NC}: $2"
        ALL_PASSED=false
    fi
}

echo "1. Checking project structure..."
echo "----------------------------------------"

# Check if TextInsertionManager.swift exists
if [ -f "LocalDictation/Core/TextInsertionManager.swift" ]; then
    print_status 0 "TextInsertionManager.swift exists"
else
    print_status 1 "TextInsertionManager.swift not found"
fi

echo ""
echo "2. Verifying TextInsertionManager implementation..."
echo "----------------------------------------"

# Check for required methods
if grep -q "func getFocusedElement()" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "getFocusedElement() method implemented"
else
    print_status 1 "getFocusedElement() method not found"
fi

if grep -q "func getCurrentText(" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "getCurrentText() method implemented"
else
    print_status 1 "getCurrentText() method not found"
fi

if grep -q "func insertTextDirect(" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "insertTextDirect() method implemented"
else
    print_status 1 "insertTextDirect() method not found"
fi

if grep -q "func insertViaClipboard(" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "insertViaClipboard() method implemented"
else
    print_status 1 "insertViaClipboard() method not found"
fi

if grep -q "func insertViaKeystrokes(" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "insertViaKeystrokes() method implemented"
else
    print_status 1 "insertViaKeystrokes() method not found"
fi

if grep -q "func insertText(" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "insertText() main method with fallback chain implemented"
else
    print_status 1 "insertText() main method not found"
fi

echo ""
echo "3. Checking error handling..."
echo "----------------------------------------"

if grep -q "enum TextInsertionError" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "TextInsertionError enum defined"
else
    print_status 1 "TextInsertionError enum not found"
fi

if grep -q "case noFocusedElement" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "noFocusedElement error case defined"
else
    print_status 1 "noFocusedElement error case not found"
fi

if grep -q "case accessibilityPermissionDenied" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "accessibilityPermissionDenied error case defined"
else
    print_status 1 "accessibilityPermissionDenied error case not found"
fi

echo ""
echo "4. Verifying Accessibility API usage..."
echo "----------------------------------------"

if grep -q "AXUIElementCreateSystemWide()" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "Uses AXUIElementCreateSystemWide() for system-wide element"
else
    print_status 1 "AXUIElementCreateSystemWide() not found"
fi

if grep -q "kAXFocusedUIElementAttribute" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "Uses kAXFocusedUIElementAttribute to get focused element"
else
    print_status 1 "kAXFocusedUIElementAttribute not found"
fi

if grep -q "kAXValueAttribute" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "Uses kAXValueAttribute for text value access"
else
    print_status 1 "kAXValueAttribute not found"
fi

if grep -q "AXUIElementSetAttributeValue" LocalDictation/Core/TextInsertionManager.swift; then
    print_status 0 "Uses AXUIElementSetAttributeValue for direct insertion"
else
    print_status 1 "AXUIElementSetAttributeValue not found"
fi

echo ""
echo "5. Checking ContentView integration..."
echo "----------------------------------------"

if grep -q "testTextInsertion" LocalDictation/UI/ContentView.swift; then
    print_status 0 "testTextInsertion() method added to ContentView"
else
    print_status 1 "testTextInsertion() method not found in ContentView"
fi

if grep -q "Text Insertion Testing (Phase 4)" LocalDictation/UI/ContentView.swift; then
    print_status 0 "Phase 4 testing UI added to ContentView"
else
    print_status 1 "Phase 4 testing UI not found in ContentView"
fi

if grep -q "Insert 'Hello World'" LocalDictation/UI/ContentView.swift; then
    print_status 0 "'Hello World' test button added"
else
    print_status 1 "'Hello World' test button not found"
fi

echo ""
echo "6. Building project..."
echo "----------------------------------------"

if xcodebuild -scheme LocalDictation -configuration Debug build > /dev/null 2>&1; then
    print_status 0 "Project builds successfully"
else
    print_status 1 "Project build failed"
fi

echo ""
echo "=========================================="
if [ "$ALL_PASSED" = true ]; then
    echo -e "${GREEN}✅ All Phase 4 verifications passed!${NC}"
    echo ""
    echo "Phase 4 is complete. Ready for manual testing:"
    echo ""
    echo "Manual Test Steps:"
    echo "1. Open TextEdit and create a new document"
    echo "2. Run the app and grant Accessibility permission if needed"
    echo "3. Click 'Insert Hello World' button"
    echo "4. Within 1 second, focus the TextEdit window"
    echo "5. Verify 'Hello World' appears in TextEdit"
    echo ""
    echo "6. Test in Safari:"
    echo "   - Open Safari and go to a site with a text input"
    echo "   - Click 'Insert Hello World' button"
    echo "   - Focus the input field within 1 second"
    echo "   - Verify text appears"
    echo ""
    echo "7. Test with transcription:"
    echo "   - Click 'Test 3-Second Recording'"
    echo "   - Speak something clearly"
    echo "   - Click 'Insert Transcription' button"
    echo "   - Focus any text field within 1 second"
    echo "   - Verify transcribed text appears"
    echo ""
    echo "8. Test across multiple apps:"
    echo "   - Notes, Messages, VS Code, Slack, etc."
    echo "   - Verify insertion works (direct or clipboard fallback)"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Some verifications failed${NC}"
    exit 1
fi
