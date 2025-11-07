//
//  PermissionsManager.swift
//  LocalDictation
//
//  Manages system permissions for microphone, speech recognition, and accessibility
//

import Foundation
import AVFoundation
import Speech
import AppKit

/// Manages all system permissions required by the app
class PermissionsManager: ObservableObject {
    static let shared = PermissionsManager()

    // MARK: - Published Properties
    @Published var microphonePermissionStatus: AVAuthorizationStatus = .notDetermined
    @Published var speechRecognitionPermissionStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @Published var accessibilityPermissionStatus: Bool = false

    // MARK: - Initialization
    private init() {
        // Don't check permissions immediately to avoid TCC crashes on startup
        // Permissions will be checked when needed
    }

    // MARK: - Public Methods

    /// Check all permissions and update status
    func checkAllPermissions() {
        checkMicrophonePermission()
        checkSpeechRecognitionPermission()
        checkAccessibilityPermission()
    }

    /// Check microphone permission status
    func checkMicrophonePermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        microphonePermissionStatus = status
        print("Microphone permission status: \(describeAuthorizationStatus(status))")
    }

    /// Check speech recognition permission status
    func checkSpeechRecognitionPermission() {
        let status = SFSpeechRecognizer.authorizationStatus()
        speechRecognitionPermissionStatus = status
        print("Speech recognition permission status: \(describeSpeechAuthorizationStatus(status))")
    }

    /// Check accessibility permission status
    func checkAccessibilityPermission() {
        let trusted = AXIsProcessTrusted()
        accessibilityPermissionStatus = trusted
        print("Accessibility permission status: \(trusted ? "Granted" : "Not Granted")")
    }

    /// Request microphone permission
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
            DispatchQueue.main.async {
                self?.checkMicrophonePermission()
                completion(granted)
            }
        }
    }

    /// Request speech recognition permission
    func requestSpeechRecognitionPermission(completion: @escaping (SFSpeechRecognizerAuthorizationStatus) -> Void) {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.checkSpeechRecognitionPermission()
                completion(status)
            }
        }
    }

    /// Request accessibility permission (opens system dialog)
    func requestAccessibilityPermission() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let trusted = AXIsProcessTrustedWithOptions(options as CFDictionary)

        DispatchQueue.main.async {
            self.accessibilityPermissionStatus = trusted
        }

        print("Accessibility permission requested, current status: \(trusted)")

        // Check again after a brief delay to see if it changed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.checkAccessibilityPermission()
        }
    }

    /// Open System Settings to Accessibility pane
    func openAccessibilitySettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }

    /// Check if all required permissions are granted
    var allPermissionsGranted: Bool {
        return microphonePermissionStatus == .authorized &&
               speechRecognitionPermissionStatus == .authorized &&
               accessibilityPermissionStatus
    }

    // MARK: - Private Helper Methods

    private func describeAuthorizationStatus(_ status: AVAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorized:
            return "Authorized"
        @unknown default:
            return "Unknown"
        }
    }

    private func describeSpeechAuthorizationStatus(_ status: SFSpeechRecognizerAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorized:
            return "Authorized"
        @unknown default:
            return "Unknown"
        }
    }
}

// MARK: - Permission Error Types
enum PermissionError: LocalizedError {
    case microphoneDenied
    case speechRecognitionDenied
    case accessibilityDenied
    case multiplePermissionsDenied([PermissionError])

    var errorDescription: String? {
        switch self {
        case .microphoneDenied:
            return "Microphone access is required to record audio"
        case .speechRecognitionDenied:
            return "Speech recognition is required to transcribe audio"
        case .accessibilityDenied:
            return "Accessibility access is required for global hotkeys and text insertion"
        case .multiplePermissionsDenied(let errors):
            return "Multiple permissions required: " + errors.compactMap { $0.errorDescription }.joined(separator: ", ")
        }
    }

    var recoverySuggestion: String? {
        return "Please grant the necessary permissions in System Settings"
    }
}