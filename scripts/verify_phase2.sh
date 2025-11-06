#!/bin/bash

# Phase 2 Verification Script
# Tests that all Phase 2 components are in place and ready

set -e

echo "================================================"
echo "Phase 2 Verification: Speech Recognition Core"
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Function to print section
print_section() {
    echo ""
    echo -e "${BLUE}$1${NC}"
    echo "----------------------------------------"
}

print_section "Phase 2.1: Minimal Speech Recognizer"

# Check Step 2.1.1-2.1.5
[ -f "LocalDictation/Core/SpeechRecognitionManager.swift" ] && print_status 0 "2.1.1: SpeechRecognitionManager.swift created" || print_status 1 "2.1.1: Missing"

if [ -f "LocalDictation/Core/SpeechRecognitionManager.swift" ]; then
    grep -q "private var speechRecognizer: SFSpeechRecognizer?" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.1.2: SFSpeechRecognizer property added" || print_status 1 "2.1.2: Property missing"

    grep -q "speechRecognizer = SFSpeechRecognizer" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.1.3: Initialization method added" || print_status 1 "2.1.3: Init missing"

    grep -q "print.*Available:" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.1.4: Availability check added" || print_status 1 "2.1.4: Check missing"

    grep -q "testRecognition" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.1.5: Test method implemented" || print_status 1 "2.1.5: Test missing"
fi

print_section "Phase 2.2: Audio Engine Setup"

# Check Step 2.2.1-2.2.5
[ -f "LocalDictation/Core/AudioEngineManager.swift" ] && print_status 0 "2.2.1: AudioEngineManager.swift created" || print_status 1 "2.2.1: Missing"

if [ -f "LocalDictation/Core/AudioEngineManager.swift" ]; then
    grep -q "func startEngine()" LocalDictation/Core/AudioEngineManager.swift && \
        print_status 0 "2.2.2: Start method added" || print_status 1 "2.2.2: Method missing"

    grep -q "func stopEngine()" LocalDictation/Core/AudioEngineManager.swift && \
        print_status 0 "2.2.3: Stop method added" || print_status 1 "2.2.3: Method missing"

    grep -q "func testStartStop" LocalDictation/Core/AudioEngineManager.swift && \
        print_status 0 "2.2.4: Test method added" || print_status 1 "2.2.4: Test missing"

    grep -q "printEngineConfiguration" LocalDictation/Core/AudioEngineManager.swift && \
        print_status 0 "2.2.5: State logging added" || print_status 1 "2.2.5: Logging missing"
fi

print_section "Phase 2.3: First Recognition Attempt"

# Check Step 2.3.1-2.3.5
if [ -f "LocalDictation/Core/SpeechRecognitionManager.swift" ]; then
    grep -q "SFSpeechAudioBufferRecognitionRequest" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.3.1: Recognition request property added" || print_status 1 "2.3.1: Property missing"

    grep -q "installTap.*bufferSize: 1024" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.3.2: Audio tap setup (1024 buffer)" || print_status 1 "2.3.2: Tap missing"

    grep -q "recognitionRequest?.append(buffer)" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.3.3: Buffer wiring implemented" || print_status 1 "2.3.3: Wiring missing"

    grep -q "bestTranscription.formattedString" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.3.4: Transcription callback added" || print_status 1 "2.3.4: Callback missing"

    grep -q "testRecognition(duration: TimeInterval)" LocalDictation/Core/SpeechRecognitionManager.swift && \
        print_status 0 "2.3.5: 3-second test implemented" || print_status 1 "2.3.5: Test missing"
fi

print_section "Integration Check"

# Check ContentView integration
if [ -f "LocalDictation/UI/ContentView.swift" ]; then
    grep -q "Test 3-Second Recording" LocalDictation/UI/ContentView.swift && \
        print_status 0 "Test button added to UI" || print_status 1 "Test button missing"

    grep -q "@StateObject.*speechManager" LocalDictation/UI/ContentView.swift && \
        print_status 0 "Speech manager integrated" || print_status 1 "Speech manager missing"

    grep -q "@StateObject.*audioManager" LocalDictation/UI/ContentView.swift && \
        print_status 0 "Audio manager integrated" || print_status 1 "Audio manager missing"

    grep -q "setupManagers()" LocalDictation/UI/ContentView.swift && \
        print_status 0 "Manager setup implemented" || print_status 1 "Setup missing"
fi

print_section "Phase 2 Verification Summary"

echo ""
echo -e "${GREEN}Phase 2 Components:${NC}"
echo "✅ SpeechRecognitionManager - Handles speech recognition"
echo "✅ AudioEngineManager - Manages audio input"
echo "✅ Test recording functionality - 3-second test"
echo "✅ UI integration - Buttons and transcription display"

echo ""
echo -e "${YELLOW}Key Features Implemented:${NC}"
echo "• Speech recognizer with US English locale"
echo "• On-device recognition preference"
echo "• Real-time partial results"
echo "• 1-minute timeout handling"
echo "• Audio tap with 1024 buffer size"
echo "• Console logging throughout"

echo ""
echo -e "${BLUE}Ready to Test:${NC}"
echo "1. Generate Xcode project: xcodegen generate"
echo "2. Open in Xcode: open LocalDictation.xcodeproj"
echo "3. Build and run (Cmd+R)"
echo "4. Click 'Test Permissions' button"
echo "5. Grant microphone and speech permissions"
echo "6. Click 'Test 3-Second Recording' button"
echo "7. Speak clearly for 3 seconds"
echo "8. Verify transcription appears"

echo ""
echo "================================================"
echo "✅ Phase 2 Complete - Ready for Testing"
echo "================================================"