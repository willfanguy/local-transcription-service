//
//  HotkeyManager.swift
//  LocalDictation
//
//  Manages global keyboard monitoring for hotkey detection
//

import Foundation
import Carbon
import CoreGraphics

/// Manages global hotkey detection via CGEvent tap
class HotkeyManager: ObservableObject {

    // MARK: - Properties

    /// The event tap for monitoring keyboard events
    private var eventTap: CFMachPort?

    /// The run loop source for the event tap
    private var runLoopSource: CFRunLoopSource?

    /// Current hotkey configuration (default: Fn key, keyCode 179 on MacBook Air)
    /// Note: Fn key code varies by model - 63 on some Macs, 179 on MacBook Air
    @Published var hotkeyKeyCode: Int = 179

    /// Recording mode: hold (press and hold) or toggle (press to start, press to stop)
    @Published var recordingMode: RecordingMode = .hold

    /// Whether the hotkey is currently pressed
    @Published var isHotkeyPressed: Bool = false

    /// Callback when hotkey is pressed
    var onHotkeyPressed: (() -> Void)?

    /// Callback when hotkey is released (for hold mode)
    var onHotkeyReleased: (() -> Void)?

    /// Whether hotkey monitoring is currently active
    var isMonitoring: Bool {
        return eventTap != nil
    }

    // MARK: - Initialization

    init() {
        print("[HotkeyManager] Initialized with default hotkey: \(hotkeyKeyCode)")
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Public Methods

    /// Start monitoring for global hotkey events
    func startMonitoring() {
        // Check if already monitoring
        guard eventTap == nil else {
            print("[HotkeyManager] Already monitoring")
            return
        }

        // Check accessibility permission
        guard AXIsProcessTrusted() else {
            print("[HotkeyManager] ERROR: Accessibility permission not granted")
            return
        }

        // Create event mask for key down and key up events
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)

        // Create the event tap
        // We need to use a bridging approach since CGEventTapCallBack requires a specific signature
        let selfPointer = Unmanaged.passUnretained(self).toOpaque()

        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, userInfo) -> Unmanaged<CGEvent>? in
                // Extract self from userInfo
                guard let userInfo = userInfo else {
                    return Unmanaged.passUnretained(event)
                }

                let manager = Unmanaged<HotkeyManager>.fromOpaque(userInfo).takeUnretainedValue()
                return manager.handleKeyEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: selfPointer
        )

        guard let eventTap = eventTap else {
            print("[HotkeyManager] ERROR: Failed to create event tap")
            return
        }

        // Create run loop source and add to main run loop
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        guard let runLoopSource = runLoopSource else {
            print("[HotkeyManager] ERROR: Failed to create run loop source")
            return
        }

        // Add to main run loop
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)

        print("[HotkeyManager] Started monitoring for hotkey: \(hotkeyKeyCode)")
    }

    /// Stop monitoring for global hotkey events
    func stopMonitoring() {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
            print("[HotkeyManager] Disabled event tap")
        }

        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
            print("[HotkeyManager] Removed run loop source")
        }

        eventTap = nil
        runLoopSource = nil

        print("[HotkeyManager] Stopped monitoring")
    }

    // MARK: - Private Methods

    /// Handle keyboard events from the event tap
    private func handleKeyEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        // Get the key code from the event
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)

        // Check if this is our hotkey
        if Int(keyCode) == hotkeyKeyCode {
            if type == .keyDown {
                handleHotkeyDown()
            } else if type == .keyUp {
                handleHotkeyUp()
            }
        }

        // Pass the event through (don't consume it)
        return Unmanaged.passUnretained(event)
    }

    /// Handle hotkey down event
    private func handleHotkeyDown() {
        // Only trigger on first press (ignore repeats)
        guard !isHotkeyPressed else { return }

        print("[HotkeyManager] Hotkey pressed (keyCode: \(hotkeyKeyCode))")

        // Update UI state and call callback on main thread
        DispatchQueue.main.async { [weak self] in
            self?.isHotkeyPressed = true
            self?.onHotkeyPressed?()
        }
    }

    /// Handle hotkey up event
    private func handleHotkeyUp() {
        guard isHotkeyPressed else { return }

        print("[HotkeyManager] Hotkey released (keyCode: \(hotkeyKeyCode))")

        // Update UI state and call callback on main thread
        let mode = recordingMode
        DispatchQueue.main.async { [weak self] in
            self?.isHotkeyPressed = false

            // For hold mode, trigger the release callback
            if mode == .hold {
                self?.onHotkeyReleased?()
            }
        }
    }

    /// Update the hotkey key code
    func setHotkey(keyCode: Int) {
        print("[HotkeyManager] Updating hotkey from \(hotkeyKeyCode) to \(keyCode)")
        hotkeyKeyCode = keyCode
    }

    /// Update the recording mode
    func setRecordingMode(_ mode: RecordingMode) {
        print("[HotkeyManager] Updating recording mode to \(mode)")
        recordingMode = mode
    }
}

// MARK: - Supporting Types

enum RecordingMode: String, CaseIterable {
    case hold = "Hold to Record"
    case toggle = "Toggle Recording"
}
