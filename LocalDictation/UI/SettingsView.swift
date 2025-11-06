import SwiftUI

/// Main settings window with tabbed interface
struct SettingsView: View {
    @ObservedObject var settings = AppSettings.shared

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
                .tag(0)

            HotkeySettingsView()
                .tabItem {
                    Label("Hotkey", systemImage: "keyboard")
                }
                .tag(1)

            RecognitionSettingsView()
                .tabItem {
                    Label("Recognition", systemImage: "waveform")
                }
                .tag(2)

            InsertionSettingsView()
                .tabItem {
                    Label("Insertion", systemImage: "text.cursor")
                }
                .tag(3)

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(4)
        }
        .frame(width: 500, height: 400)
    }
}

// MARK: - General Settings Tab

struct GeneralSettingsView: View {
    @ObservedObject var settings = AppSettings.shared

    var body: some View {
        Form {
            Section {
                Toggle("Launch at Login", isOn: $settings.launchAtLogin)
                    .help("Automatically start Local Dictation when you log in")

                Toggle("Show Transcription Overlay", isOn: $settings.showOverlay)
                    .help("Display a floating window with real-time transcription while recording")
            } header: {
                Text("Startup")
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - Hotkey Settings Tab

struct HotkeySettingsView: View {
    @ObservedObject var settings = AppSettings.shared
    @State private var isRecordingHotkey = false

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Current Hotkey:")
                    Spacer()
                    Text(keyCodeDisplayName(settings.hotkeyKeyCode))
                        .foregroundColor(.secondary)
                        .font(.system(.body, design: .monospaced))
                }

                Button(isRecordingHotkey ? "Press any key..." : "Change Hotkey") {
                    isRecordingHotkey.toggle()
                }
                .help("Click and then press the key you want to use as your dictation hotkey")

                Text("Current key code: \(settings.hotkeyKeyCode)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Hotkey Configuration")
            }

            Section {
                Picker("Recording Mode", selection: $settings.recordingMode) {
                    ForEach(RecordingMode.allCases) { mode in
                        VStack(alignment: .leading) {
                            Text(mode.displayName)
                            Text(mode.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .tag(mode)
                    }
                }
                .pickerStyle(.radioGroup)
            } header: {
                Text("Behavior")
            }
        }
        .formStyle(.grouped)
        .padding()
    }

    private func keyCodeDisplayName(_ keyCode: Int) -> String {
        switch keyCode {
        case 63: return "Fn"
        case 36: return "Return"
        case 48: return "Tab"
        case 49: return "Space"
        case 51: return "Delete"
        case 53: return "Escape"
        case 123: return "Left Arrow"
        case 124: return "Right Arrow"
        case 125: return "Down Arrow"
        case 126: return "Up Arrow"
        default: return "Key \(keyCode)"
        }
    }
}

// MARK: - Recognition Settings Tab

struct RecognitionSettingsView: View {
    @ObservedObject var settings = AppSettings.shared

    var body: some View {
        Form {
            Section {
                Picker("Language", selection: $settings.recognitionLanguage) {
                    ForEach(AppSettings.supportedLanguages, id: \.code) { language in
                        Text(language.name).tag(language.code)
                    }
                }
                .pickerStyle(.menu)

                Text("Current: \(settings.currentLanguageName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Speech Recognition")
            }

            Section {
                Toggle("Prefer On-Device Recognition", isOn: $settings.preferOnDeviceRecognition)
                    .help("Use on-device speech recognition when available for better privacy")

                Text("On-device recognition keeps your audio private and works offline, but may not be available for all languages.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } header: {
                Text("Privacy")
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - Insertion Settings Tab

struct InsertionSettingsView: View {
    @ObservedObject var settings = AppSettings.shared

    var body: some View {
        Form {
            Section {
                Picker("Text Insertion Method", selection: $settings.insertionMethod) {
                    ForEach(InsertionMethod.allCases) { method in
                        VStack(alignment: .leading) {
                            Text(method.displayName)
                            Text(method.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .tag(method)
                    }
                }
                .pickerStyle(.radioGroup)
            } header: {
                Text("Method")
            }

            Section {
                Text("Automatic mode (recommended) tries methods in order until one succeeds:")
                    .font(.caption)
                    .foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("1.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Direct Accessibility API")
                            .font(.caption)
                    }
                    HStack {
                        Text("2.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Clipboard Paste (Cmd+V)")
                            .font(.caption)
                    }
                    HStack {
                        Text("3.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Simulated Typing")
                            .font(.caption)
                    }
                }
                .padding(.top, 4)
            } header: {
                Text("About Insertion Methods")
            }
        }
        .formStyle(.grouped)
        .padding()
    }
}

// MARK: - About Tab

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "mic.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)

            Text("Local Dictation")
                .font(.title)
                .fontWeight(.bold)

            Text("Version 1.0")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Divider()
                .padding(.horizontal, 40)

            VStack(spacing: 8) {
                Text("System-wide voice dictation for macOS")
                    .font(.body)
                    .multilineTextAlignment(.center)

                Text("Uses Apple's Speech framework for privacy-focused transcription")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 12) {
                Link("GitHub Repository", destination: URL(string: "https://github.com/yourusername/local-dictation")!)
                    .font(.caption)

                Text("© 2025 Your Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview

#Preview {
    SettingsView()
}
