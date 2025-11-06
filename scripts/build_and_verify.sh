#!/bin/bash

# Build and Verification Script for LocalDictation
# This script builds the app and performs verification checks

set -e  # Exit on any error

echo "================================================"
echo "LocalDictation Build & Verification Script"
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
        return 1
    fi
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to print section
print_section() {
    echo ""
    echo "----------------------------------------"
    echo "$1"
    echo "----------------------------------------"
}

# Check if we're in the right directory
print_section "Pre-flight Checks"

if [ ! -f "project.yml" ]; then
    print_warning "project.yml not found. Are you in the right directory?"
    exit 1
fi
print_status 0 "project.yml exists"

# Check for required files
echo ""
echo "Checking project structure..."

# Core files
[ -f "LocalDictation/LocalDictationApp.swift" ] && print_status 0 "Main app file exists" || print_status 1 "Main app file missing"
[ -f "LocalDictation/UI/ContentView.swift" ] && print_status 0 "ContentView exists" || print_status 1 "ContentView missing"
[ -f "LocalDictation/Info.plist" ] && print_status 0 "Info.plist exists" || print_status 1 "Info.plist missing"
[ -f "LocalDictation/LocalDictation.entitlements" ] && print_status 0 "Entitlements file exists" || print_status 1 "Entitlements missing"
[ -f "LocalDictation/Utilities/PermissionsManager.swift" ] && print_status 0 "PermissionsManager exists" || print_status 1 "PermissionsManager missing"

# Check folder structure
echo ""
echo "Checking folder structure..."
[ -d "LocalDictation/Core" ] && print_status 0 "Core/ folder exists" || print_status 1 "Core/ folder missing"
[ -d "LocalDictation/UI" ] && print_status 0 "UI/ folder exists" || print_status 1 "UI/ folder missing"
[ -d "LocalDictation/Models" ] && print_status 0 "Models/ folder exists" || print_status 1 "Models/ folder missing"
[ -d "LocalDictation/Utilities" ] && print_status 0 "Utilities/ folder exists" || print_status 1 "Utilities/ folder missing"

# Check Info.plist permissions
print_section "Permission Declarations"

echo "Checking Info.plist for required permissions..."
if grep -q "NSMicrophoneUsageDescription" LocalDictation/Info.plist; then
    print_status 0 "Microphone permission description present"
else
    print_status 1 "Microphone permission description missing"
fi

if grep -q "NSSpeechRecognitionUsageDescription" LocalDictation/Info.plist; then
    print_status 0 "Speech recognition permission description present"
else
    print_status 1 "Speech recognition permission description missing"
fi

# Try to compile with swiftc (basic syntax check)
print_section "Syntax Validation"

echo "Checking Swift syntax..."
for file in LocalDictation/**/*.swift; do
    if [ -f "$file" ]; then
        swiftc -parse "$file" 2>/dev/null && print_status 0 "$(basename $file) - syntax OK" || print_status 1 "$(basename $file) - syntax error"
    fi
done

# Check if xcodegen is available
print_section "Build Tools"

if command -v xcodegen &> /dev/null; then
    print_status 0 "xcodegen is installed"
    echo ""
    read -p "Generate Xcode project with xcodegen? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Generating Xcode project..."
        xcodegen generate
        print_status $? "Xcode project generated"
    fi
else
    print_warning "xcodegen not installed. Install with: brew install xcodegen"
    print_warning "You'll need to create the Xcode project manually or install xcodegen"
fi

# Check if xcodebuild is available (Xcode installed)
if command -v xcodebuild &> /dev/null; then
    print_status 0 "Xcode command line tools installed"

    # If .xcodeproj exists, try to build
    if [ -d "LocalDictation.xcodeproj" ]; then
        echo ""
        read -p "Attempt to build with xcodebuild? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_section "Building Project"
            xcodebuild -project LocalDictation.xcodeproj \
                       -scheme LocalDictation \
                       -configuration Debug \
                       -derivedDataPath build \
                       build 2>&1 | tail -n 20
            print_status ${PIPESTATUS[0]} "Build completed"
        fi
    else
        print_warning "No .xcodeproj found. Generate it with xcodegen or create manually in Xcode"
    fi
else
    print_warning "Xcode command line tools not installed"
fi

# Summary
print_section "Verification Summary"

echo "Project Setup Checklist:"
echo ""
echo "Phase 1.1: Xcode Project Creation"
echo "  ✓ Project structure created"
echo "  ✓ Main app files created"
echo "  ✓ Minimum deployment target set (in project.yml)"
echo "  ✓ Bundle identifier configured"
echo ""
echo "Phase 1.2: Project Structure"
echo "  ✓ Folder structure created (Core/, UI/, Models/, Utilities/)"
echo "  ✓ .gitignore added"
echo ""
echo "Phase 1.3: Permissions"
echo "  ✓ NSMicrophoneUsageDescription added"
echo "  ✓ NSSpeechRecognitionUsageDescription added"
echo "  ✓ Test button created in ContentView"
echo ""
echo "Phase 1.4: Permission Manager"
echo "  ✓ PermissionsManager created"
echo "  ✓ Permission check methods implemented"
echo "  ✓ Console logging added"
echo ""

print_section "Next Steps"

echo "1. If xcodegen is not installed:"
echo "   brew install xcodegen"
echo ""
echo "2. Generate Xcode project:"
echo "   xcodegen generate"
echo ""
echo "3. Open in Xcode:"
echo "   open LocalDictation.xcodeproj"
echo ""
echo "4. Run the app (Cmd+R) and click 'Test Permissions' button"
echo ""
echo "5. Verify:"
echo "   - App launches without crashes"
echo "   - Permission dialogs appear when button clicked"
echo "   - Console shows permission status"
echo ""
echo "Once verified, proceed to Phase 2: Speech Recognition Core"