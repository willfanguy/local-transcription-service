#!/bin/bash

# Phase 6 Verification Script - Settings & Preferences
# Verifies that settings UI is implemented and integrated with managers

echo "=========================================="
echo "Phase 6 Verification: Settings & Preferences"
echo "=========================================="
echo ""

ERRORS=0

# Check if AppSettings model exists
echo "✓ Checking AppSettings model..."
if [ -f "LocalDictation/Models/AppSettings.swift" ]; then
    echo "  ✅ AppSettings.swift exists"

    # Verify key properties
    if grep -q "@AppStorage.*hotkeyKeyCode" LocalDictation/Models/AppSettings.swift; then
        echo "  ✅ hotkeyKeyCode property defined"
    else
        echo "  ❌ hotkeyKeyCode property missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "@AppStorage.*recordingMode" LocalDictation/Models/AppSettings.swift; then
        echo "  ✅ recordingMode property defined"
    else
        echo "  ❌ recordingMode property missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "@AppStorage.*recognitionLanguage" LocalDictation/Models/AppSettings.swift; then
        echo "  ✅ recognitionLanguage property defined"
    else
        echo "  ❌ recognitionLanguage property missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "@AppStorage.*showOverlay" LocalDictation/Models/AppSettings.swift; then
        echo "  ✅ showOverlay property defined"
    else
        echo "  ❌ showOverlay property missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "@AppStorage.*insertionMethod" LocalDictation/Models/AppSettings.swift; then
        echo "  ✅ insertionMethod property defined"
    else
        echo "  ❌ insertionMethod property missing"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ❌ AppSettings.swift not found"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check if SettingsView exists
echo "✓ Checking SettingsView..."
if [ -f "LocalDictation/UI/SettingsView.swift" ]; then
    echo "  ✅ SettingsView.swift exists"

    # Check for tab views
    if grep -q "GeneralSettingsView" LocalDictation/UI/SettingsView.swift; then
        echo "  ✅ GeneralSettingsView defined"
    else
        echo "  ❌ GeneralSettingsView missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "HotkeySettingsView" LocalDictation/UI/SettingsView.swift; then
        echo "  ✅ HotkeySettingsView defined"
    else
        echo "  ❌ HotkeySettingsView missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "RecognitionSettingsView" LocalDictation/UI/SettingsView.swift; then
        echo "  ✅ RecognitionSettingsView defined"
    else
        echo "  ❌ RecognitionSettingsView missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "InsertionSettingsView" LocalDictation/UI/SettingsView.swift; then
        echo "  ✅ InsertionSettingsView defined"
    else
        echo "  ❌ InsertionSettingsView missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "AboutView" LocalDictation/UI/SettingsView.swift; then
        echo "  ✅ AboutView defined"
    else
        echo "  ❌ AboutView missing"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ❌ SettingsView.swift not found"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check AppDelegate integration
echo "✓ Checking AppDelegate integration..."
if [ -f "LocalDictation/AppDelegate.swift" ]; then
    if grep -q "let settings = AppSettings.shared" LocalDictation/AppDelegate.swift; then
        echo "  ✅ AppSettings integrated in AppDelegate"
    else
        echo "  ❌ AppSettings not integrated in AppDelegate"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "openSettings" LocalDictation/AppDelegate.swift; then
        echo "  ✅ openSettings method exists"
    else
        echo "  ❌ openSettings method missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "SettingsView()" LocalDictation/AppDelegate.swift; then
        echo "  ✅ SettingsView instantiated in openSettings"
    else
        echo "  ❌ SettingsView not instantiated"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "settings.hotkeyKeyCode" LocalDictation/AppDelegate.swift; then
        echo "  ✅ Hotkey settings applied"
    else
        echo "  ❌ Hotkey settings not applied"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "settings.showOverlay" LocalDictation/AppDelegate.swift; then
        echo "  ✅ Overlay settings respected"
    else
        echo "  ❌ Overlay settings not used"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ❌ AppDelegate.swift not found"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check SpeechRecognitionManager language support
echo "✓ Checking SpeechRecognitionManager language support..."
if [ -f "LocalDictation/Core/SpeechRecognitionManager.swift" ]; then
    if grep -q "func setLanguage" LocalDictation/Core/SpeechRecognitionManager.swift; then
        echo "  ✅ setLanguage method exists"
    else
        echo "  ❌ setLanguage method missing"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ❌ SpeechRecognitionManager.swift not found"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check TextInsertionManager method support
echo "✓ Checking TextInsertionManager insertion methods..."
if [ -f "LocalDictation/Core/TextInsertionManager.swift" ]; then
    if grep -q "func insertTextDirect.*throws" LocalDictation/Core/TextInsertionManager.swift; then
        echo "  ✅ insertTextDirect public method exists"
    else
        echo "  ❌ insertTextDirect public method missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "func insertViaClipboard" LocalDictation/Core/TextInsertionManager.swift; then
        echo "  ✅ insertViaClipboard method exists"
    else
        echo "  ❌ insertViaClipboard method missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "func insertViaKeystrokes" LocalDictation/Core/TextInsertionManager.swift; then
        echo "  ✅ insertViaKeystrokes method exists"
    else
        echo "  ❌ insertViaKeystrokes method missing"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ❌ TextInsertionManager.swift not found"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Check for RecordingMode enum
echo "✓ Checking RecordingMode enum..."
if grep -q "enum RecordingMode" LocalDictation/Models/AppSettings.swift; then
    echo "  ✅ RecordingMode defined in AppSettings"

    if grep -q "case hold" LocalDictation/Models/AppSettings.swift; then
        echo "  ✅ 'hold' mode defined"
    else
        echo "  ❌ 'hold' mode missing"
        ERRORS=$((ERRORS + 1))
    fi

    if grep -q "case toggle" LocalDictation/Models/AppSettings.swift; then
        echo "  ✅ 'toggle' mode defined"
    else
        echo "  ❌ 'toggle' mode missing"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ❌ RecordingMode enum not found in AppSettings"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Summary
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo "✅ All Phase 6 checks passed!"
    echo "=========================================="
    echo ""
    echo "Manual Testing Required:"
    echo "1. Run the app and open Settings from menu bar"
    echo "2. Verify all 5 tabs are accessible"
    echo "3. Change recording mode and test hold vs toggle"
    echo "4. Toggle 'Show Overlay' and verify overlay shows/hides"
    echo "5. Change language and verify recognition updates"
    echo "6. Change insertion method and test text insertion"
    echo "7. Quit and restart app - verify settings persist"
    echo "8. Change hotkey key code via Debug menu and verify it works"
    echo ""
    exit 0
else
    echo "❌ Phase 6 verification failed with $ERRORS error(s)"
    echo "=========================================="
    exit 1
fi
