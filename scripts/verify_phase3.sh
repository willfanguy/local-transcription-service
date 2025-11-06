#!/bin/bash

# Phase 3 Verification Script
# Verifies that Global Hotkey Detection is implemented correctly

set -e

echo "===================================="
echo "Phase 3 Verification: Global Hotkey Detection"
echo "===================================="
echo ""

# Check if we're in the correct directory
if [ ! -f "project.yml" ]; then
    echo "❌ Error: Must be run from project root"
    exit 1
fi

echo "1. Checking file structure..."

# Check that HotkeyManager exists
if [ ! -f "LocalDictation/Core/HotkeyManager.swift" ]; then
    echo "❌ HotkeyManager.swift not found"
    exit 1
fi
echo "✅ HotkeyManager.swift exists"

# Check that PermissionsManager still exists
if [ ! -f "LocalDictation/Utilities/PermissionsManager.swift" ]; then
    echo "❌ PermissionsManager.swift not found"
    exit 1
fi
echo "✅ PermissionsManager.swift exists"

echo ""
echo "2. Checking HotkeyManager implementation..."

# Check for key components in HotkeyManager
if ! grep -q "CFMachPort" "LocalDictation/Core/HotkeyManager.swift"; then
    echo "❌ CFMachPort not found - event tap not implemented"
    exit 1
fi
echo "✅ Uses CFMachPort for event tap"

if ! grep -q "CGEvent.tapCreate" "LocalDictation/Core/HotkeyManager.swift"; then
    echo "❌ CGEvent.tapCreate not found"
    exit 1
fi
echo "✅ Creates event tap with CGEvent.tapCreate"

if ! grep -q "startMonitoring" "LocalDictation/Core/HotkeyManager.swift"; then
    echo "❌ startMonitoring method not found"
    exit 1
fi
echo "✅ Has startMonitoring method"

if ! grep -q "stopMonitoring" "LocalDictation/Core/HotkeyManager.swift"; then
    echo "❌ stopMonitoring method not found"
    exit 1
fi
echo "✅ Has stopMonitoring method"

if ! grep -q "onHotkeyPressed" "LocalDictation/Core/HotkeyManager.swift"; then
    echo "❌ onHotkeyPressed callback not found"
    exit 1
fi
echo "✅ Has onHotkeyPressed callback"

if ! grep -q "onHotkeyReleased" "LocalDictation/Core/HotkeyManager.swift"; then
    echo "❌ onHotkeyReleased callback not found"
    exit 1
fi
echo "✅ Has onHotkeyReleased callback"

if ! grep -q "RecordingMode" "LocalDictation/Core/HotkeyManager.swift"; then
    echo "❌ RecordingMode enum not found"
    exit 1
fi
echo "✅ Has RecordingMode enum (hold/toggle)"

echo ""
echo "3. Checking PermissionsManager accessibility support..."

if ! grep -q "checkAccessibilityPermission" "LocalDictation/Utilities/PermissionsManager.swift"; then
    echo "❌ checkAccessibilityPermission method not found"
    exit 1
fi
echo "✅ Has checkAccessibilityPermission method"

if ! grep -q "AXIsProcessTrusted" "LocalDictation/Utilities/PermissionsManager.swift"; then
    echo "❌ AXIsProcessTrusted not found"
    exit 1
fi
echo "✅ Uses AXIsProcessTrusted"

if ! grep -q "requestAccessibilityPermission" "LocalDictation/Utilities/PermissionsManager.swift"; then
    echo "❌ requestAccessibilityPermission method not found"
    exit 1
fi
echo "✅ Has requestAccessibilityPermission method"

if ! grep -q "openAccessibilitySettings" "LocalDictation/Utilities/PermissionsManager.swift"; then
    echo "❌ openAccessibilitySettings method not found"
    exit 1
fi
echo "✅ Has openAccessibilitySettings method"

echo ""
echo "4. Checking ContentView integration..."

if ! grep -q "HotkeyManager" "LocalDictation/UI/ContentView.swift"; then
    echo "❌ HotkeyManager not integrated in ContentView"
    exit 1
fi
echo "✅ HotkeyManager integrated in ContentView"

if ! grep -q "toggleHotkeyMonitoring" "LocalDictation/UI/ContentView.swift"; then
    echo "❌ toggleHotkeyMonitoring method not found in ContentView"
    exit 1
fi
echo "✅ Has toggleHotkeyMonitoring method"

echo ""
echo "5. Building project..."

xcodegen generate > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ xcodegen generate failed"
    exit 1
fi
echo "✅ XcodeGen project generation successful"

xcodebuild -scheme LocalDictation -configuration Debug build > /tmp/phase3_build.log 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Build failed. Check /tmp/phase3_build.log for details"
    exit 1
fi
echo "✅ Project builds successfully"

echo ""
echo "===================================="
echo "✅ Phase 3 Verification PASSED"
echo "===================================="
echo ""
echo "Next steps to test manually:"
echo "1. Run the app in Xcode (Cmd+R)"
echo "2. Click 'Request' to enable Accessibility permission"
echo "3. Grant permission in System Settings"
echo "4. Click 'Start Hotkey Monitoring'"
echo "5. Press the Fn key - you should see '🔴 Fn Key Pressed!'"
echo "6. Check console logs for '[HotkeyManager] Hotkey pressed'"
echo ""
echo "Ready to proceed to Phase 4: Text Insertion"
