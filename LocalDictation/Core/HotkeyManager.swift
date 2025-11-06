//
//  HotkeyManager.swift
//  LocalDictation
//
//  Manages global keyboard monitoring for hotkey detection
//

import Foundation
import AppKit
import Carbon

/// Manages global hotkey detection via NSEvent monitors
class HotkeyManager: ObservableObject {

    // MARK: - Properties

    /// Local event monitor (for events when app is active)
    private var localMonitor: Any?

    /// Global event monitor (for events when app is in background)
    private var globalMonitor: Any?

    /// Current hotkey configuration (default: Fn key, keyCode 63)
    /// Note: Fn key code is typically 63 on most modern Macs
    @Published var hotkeyKeyCode: Int = 63

    /// Recording mode: hold (press and hold) or toggle (press to start, press to stop)
    @Published var recordingMode: RecordingMode = .hold

    /// Whether the hotkey is currently pressed
    @Published var isHotkeyPressed: Bool = false

    /// Debug mode: logs all key presses to help identify the correct keyCode
    @Published var debugMode: Bool = false

    /// Callback when hotkey is pressed
    var onHotkeyPressed: (() -> Void)?

    /// Callback when hotkey is released (for hold mode)
    var onHotkeyReleased: (() -> Void)?

    /// Whether hotkey monitoring is currently active
    var isMonitoring: Bool {
        return localMonitor != nil || globalMonitor != nil
    }

    // Track key state
    private var trackedKeys: Set<UInt16> = []

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
        print("[HotkeyManager] ===== startMonitoring() called =====")

        // Check if already monitoring
        guard localMonitor == nil && globalMonitor == nil else {
            print("[HotkeyManager] Already monitoring - localMonitor: \(localMonitor != nil), globalMonitor: \(globalMonitor != nil)")
            return
        }

        // Check accessibility permission
        let trusted = AXIsProcessTrusted()
        print("[HotkeyManager] Accessibility permission check: \(trusted)")
        guard trusted else {
            print("[HotkeyManager] ERROR: Accessibility permission not granted")
            return
        }

        // Monitor local events (when app is focused)
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp, .flagsChanged]) { [weak self] event in
            self?.handleNSEvent(event)
            return event // Pass through
        }

        // Monitor global events (when app is in background)
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown, .keyUp, .flagsChanged]) { [weak self] event in
            self?.handleNSEvent(event)
        }

        print("[HotkeyManager] ===== Monitoring started successfully =====")
        print("[HotkeyManager] Watching for keyCode: \(hotkeyKeyCode)")
        print("[HotkeyManager] Debug mode: \(debugMode)")
        print("[HotkeyManager] Try pressing ANY key now - you should see events above")
    }

    /// Stop monitoring for global hotkey events
    func stopMonitoring() {
        if let localMonitor = localMonitor {
            NSEvent.removeMonitor(localMonitor)
            self.localMonitor = nil
            print("[HotkeyManager] Removed local monitor")
        }

        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
            self.globalMonitor = nil
            print("[HotkeyManager] Removed global monitor")
        }

        print("[HotkeyManager] Stopped monitoring")
    }

    // MARK: - Private Methods

    /// Handle NSEvent from monitors
    private func handleNSEvent(_ event: NSEvent) {
        let keyCode = event.keyCode

        // Log in debug mode only
        if debugMode {
            switch event.type {
            case .keyDown:
                print("[HotkeyManager] DEBUG: keyDown - keyCode: \(keyCode)")
            case .keyUp:
                print("[HotkeyManager] DEBUG: keyUp - keyCode: \(keyCode)")
            case .flagsChanged:
                print("[HotkeyManager] DEBUG: flagsChanged - keyCode: \(keyCode), modifiers: \(event.modifierFlags)")
            default:
                print("[HotkeyManager] DEBUG: OTHER EVENT - type: \(event.type.rawValue)")
            }
        }

        // Check if this is our hotkey
        if Int(keyCode) == hotkeyKeyCode {
            switch event.type {
            case .keyDown:
                if !trackedKeys.contains(keyCode) {
                    trackedKeys.insert(keyCode)
                    handleHotkeyDown()
                }
            case .keyUp:
                if trackedKeys.contains(keyCode) {
                    trackedKeys.remove(keyCode)
                    handleHotkeyUp()
                }
            case .flagsChanged:
                // Some keys (like Fn) send flagsChanged instead of keyDown/keyUp
                // Check if the key is now pressed or released
                let isPressed = event.modifierFlags.contains(.function) ||
                               event.modifierFlags.contains(.command) ||
                               event.modifierFlags.contains(.option) ||
                               event.modifierFlags.contains(.control)

                if isPressed && !trackedKeys.contains(keyCode) {
                    trackedKeys.insert(keyCode)
                    handleHotkeyDown()
                } else if !isPressed && trackedKeys.contains(keyCode) {
                    trackedKeys.remove(keyCode)
                    handleHotkeyUp()
                }
            default:
                break
            }
        }
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
