#!/bin/bash

# test_crash.sh - Automated testing script for Local Dictation crash debugging
# This script builds the app with debugging enabled and runs it with special flags

set -e

echo "=========================================="
echo "Local Dictation Crash Test Runner"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="$(pwd)"
BUILD_DIR="${PROJECT_DIR}/build"
LOG_DIR="${HOME}/Documents/LocalDictation/debug_logs"
CRASH_LOG_DIR="${HOME}/Library/Logs/DiagnosticReports"
APP_NAME="LocalDictation"
SCHEME="LocalDictation"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Create directories
mkdir -p "${BUILD_DIR}"
mkdir -p "${LOG_DIR}"

# Clean previous build
print_status "Cleaning previous build..."
xcodebuild clean -scheme "${SCHEME}" -configuration Debug > /dev/null 2>&1 || true

# Build with debugging enabled
print_status "Building with debugging enabled..."
echo "  Configuration: Debug"
echo "  Scheme: ${SCHEME}"
echo "  Build directory: ${BUILD_DIR}"

xcodebuild build \
    -scheme "${SCHEME}" \
    -configuration Debug \
    -derivedDataPath "${BUILD_DIR}" \
    ENABLE_ADDRESS_SANITIZER=YES \
    ENABLE_ZOMBIE_OBJECTS=YES \
    DEBUG_INFORMATION_FORMAT=dwarf-with-dsym \
    GCC_OPTIMIZATION_LEVEL=0 \
    SWIFT_OPTIMIZATION_LEVEL=-Onone \
    OTHER_SWIFT_FLAGS="-D DEBUG" \
    | xcpretty

if [ $? -ne 0 ]; then
    print_error "Build failed!"
    exit 1
fi

print_status "Build completed successfully"

# Find the built app
APP_PATH=$(find "${BUILD_DIR}" -name "${APP_NAME}.app" -type d | head -1)

if [ -z "${APP_PATH}" ]; then
    print_error "Could not find built app!"
    exit 1
fi

print_status "Found app at: ${APP_PATH}"

# Check for existing crash logs
EXISTING_CRASHES=$(ls "${CRASH_LOG_DIR}/${APP_NAME}"*.crash 2>/dev/null | wc -l | tr -d ' ')
print_status "Existing crash logs: ${EXISTING_CRASHES}"

# Export environment variables for debugging
export MALLOC_STACK_LOGGING=1
export MallocStackLogging=1
export MallocScribble=1
export MallocGuardEdges=1
export NSZombieEnabled=YES
export NSDebugEnabled=YES
export OBJC_DEBUG_MISSING_POOLS=YES
export OBJC_DEBUG_POOL_ALLOCATION=YES
export OBJC_DEBUG_FRAGILE_SUPERCLASSES=YES

print_status "Debug environment variables set"

# Create a timestamp for this test run
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TEST_LOG="${LOG_DIR}/test_run_${TIMESTAMP}.log"

# Function to monitor for new crashes
monitor_crashes() {
    local start_count=$1
    local current_count=$(ls "${CRASH_LOG_DIR}/${APP_NAME}"*.crash 2>/dev/null | wc -l | tr -d ' ')

    if [ "$current_count" -gt "$start_count" ]; then
        print_error "NEW CRASH DETECTED!"

        # Find the newest crash log
        NEWEST_CRASH=$(ls -t "${CRASH_LOG_DIR}/${APP_NAME}"*.crash 2>/dev/null | head -1)

        if [ -n "${NEWEST_CRASH}" ]; then
            CRASH_COPY="${LOG_DIR}/crash_${TIMESTAMP}.crash"
            cp "${NEWEST_CRASH}" "${CRASH_COPY}"
            print_status "Crash log copied to: ${CRASH_COPY}"

            # Display crash summary
            echo ""
            echo "=== CRASH SUMMARY ==="
            grep -A 5 "Exception Type:" "${NEWEST_CRASH}" || true
            grep -A 10 "Crashed Thread:" "${NEWEST_CRASH}" || true
            echo "===================="
        fi

        return 1
    fi

    return 0
}

# Run the app with logging
print_status "Starting app with debug logging..."
echo "  Log output: ${TEST_LOG}"
echo ""
print_warning "Please perform the following test sequence:"
echo "  1. Grant all required permissions (Microphone, Speech, Accessibility)"
echo "  2. Open the Debug menu → Crash Test Harness"
echo "  3. Select 'Rapid Start/Stop' test"
echo "  4. Click 'Run Test'"
echo "  5. Watch for crashes"
echo ""
echo "Press Ctrl+C to stop monitoring when done"
echo ""

# Start the app and redirect output to log file
"${APP_PATH}/Contents/MacOS/${APP_NAME}" --debug-logging 2>&1 | tee "${TEST_LOG}" &
APP_PID=$!

print_status "App started with PID: ${APP_PID}"

# Monitor for crashes
print_status "Monitoring for crashes..."
while kill -0 $APP_PID 2>/dev/null; do
    if ! monitor_crashes $EXISTING_CRASHES; then
        print_error "Crash detected! Check logs for details."
        kill $APP_PID 2>/dev/null || true
        break
    fi
    sleep 1
done

# Check if app is still running
if kill -0 $APP_PID 2>/dev/null; then
    print_warning "Stopping app..."
    kill $APP_PID
fi

# Final check for crashes
monitor_crashes $EXISTING_CRASHES

# Analyze logs
print_status "Analyzing logs..."

echo ""
echo "=== LOG SUMMARY ==="
echo "Test log: ${TEST_LOG}"
echo "Debug logs directory: ${LOG_DIR}"

# Look for key events in the log
if [ -f "${TEST_LOG}" ]; then
    echo ""
    echo "Key events found:"
    grep -c "START_RECORDING_CALLED" "${TEST_LOG}" 2>/dev/null && echo "  - Start recording calls: $(grep -c "START_RECORDING_CALLED" "${TEST_LOG}")" || true
    grep -c "STOP_RECORDING_CALLED" "${TEST_LOG}" 2>/dev/null && echo "  - Stop recording calls: $(grep -c "STOP_RECORDING_CALLED" "${TEST_LOG}")" || true
    grep -c "RECOGNITION_STARTED_SUCCESSFULLY" "${TEST_LOG}" 2>/dev/null && echo "  - Successful starts: $(grep -c "RECOGNITION_STARTED_SUCCESSFULLY" "${TEST_LOG}")" || true
    grep -c "ERROR" "${TEST_LOG}" 2>/dev/null && echo "  - Errors: $(grep -c "ERROR" "${TEST_LOG}")" || true
    grep -c "WARNING" "${TEST_LOG}" 2>/dev/null && echo "  - Warnings: $(grep -c "WARNING" "${TEST_LOG}")" || true
fi

echo ""
echo "=========================================="
echo "Test run complete"
echo "=========================================="

# Optional: Open log in Console app
read -p "Open logs in Console app? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open -a Console "${TEST_LOG}"
fi