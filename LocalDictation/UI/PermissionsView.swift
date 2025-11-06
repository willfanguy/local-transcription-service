//
//  PermissionsView.swift
//  LocalDictation
//
//  Permissions management view
//

import SwiftUI
import AVFoundation
import Speech

struct PermissionsView: View {
    @StateObject private var permissionsManager = PermissionsManager.shared

    var body: some View {
        VStack(spacing: 20) {
            Text("Permissions Required")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Local Dictation needs the following permissions to function:")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 15) {
                // Microphone Permission
                PermissionRow(
                    icon: "mic.fill",
                    title: "Microphone",
                    description: "To listen to your voice",
                    status: {
                        switch permissionsManager.microphonePermissionStatus {
                        case .authorized: return .granted
                        case .denied: return .denied
                        case .notDetermined: return .notDetermined
                        case .restricted: return .denied
                        @unknown default: return .notDetermined
                        }
                    }(),
                    onRequest: {
                        permissionsManager.requestMicrophonePermission { _ in
                            permissionsManager.checkAllPermissions()
                        }
                    }
                )

                // Speech Recognition Permission
                PermissionRow(
                    icon: "waveform",
                    title: "Speech Recognition",
                    description: "To transcribe your speech",
                    status: {
                        switch permissionsManager.speechRecognitionPermissionStatus {
                        case .authorized: return .granted
                        case .denied: return .denied
                        case .notDetermined: return .notDetermined
                        case .restricted: return .denied
                        @unknown default: return .notDetermined
                        }
                    }(),
                    onRequest: {
                        permissionsManager.requestSpeechRecognitionPermission { _ in
                            permissionsManager.checkAllPermissions()
                        }
                    }
                )

                // Accessibility Permission
                PermissionRow(
                    icon: "hand.point.up.left.fill",
                    title: "Accessibility",
                    description: "To detect hotkey and insert text",
                    status: permissionsManager.accessibilityPermissionStatus ? .granted : .denied,
                    onRequest: {
                        permissionsManager.requestAccessibilityPermission()
                    },
                    onOpenSettings: {
                        permissionsManager.openAccessibilitySettings()
                    }
                )
            }

            Divider()

            if permissionsManager.allPermissionsGranted {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("All permissions granted!")
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
            } else {
                Text("Grant all permissions to use Local Dictation")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(30)
        .frame(width: 500)
        .onAppear {
            permissionsManager.checkAllPermissions()
        }
    }
}

enum PermissionStatus {
    case granted
    case denied
    case notDetermined
}

struct PermissionRow: View {
    let icon: String
    let title: String
    let description: String
    let status: PermissionStatus
    var onRequest: () -> Void
    var onOpenSettings: (() -> Void)?

    var body: some View {
        HStack(spacing: 15) {
            // Icon
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Status and action
            HStack(spacing: 10) {
                if status == .granted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Button("Grant") {
                        onRequest()
                    }
                    .buttonStyle(.borderedProminent)

                    if let openSettings = onOpenSettings {
                        Button("Open Settings") {
                            openSettings()
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    PermissionsView()
}
