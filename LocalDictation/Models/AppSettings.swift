import Foundation
import SwiftUI

/// User-configurable app settings persisted via UserDefaults
class AppSettings: ObservableObject {

    // MARK: - General Settings

    @AppStorage("launchAtLogin") var launchAtLogin: Bool = false
    @AppStorage("showOverlay") var showOverlay: Bool = true

    // MARK: - Hotkey Settings

    @AppStorage("hotkeyKeyCode") var hotkeyKeyCode: Int = 63 // Default: Fn key
    @AppStorage("recordingMode") var recordingMode: RecordingMode = .hold

    // MARK: - Recognition Settings

    @AppStorage("recognitionLanguage") var recognitionLanguage: String = "en-US"
    @AppStorage("preferOnDeviceRecognition") var preferOnDeviceRecognition: Bool = true

    // MARK: - Insertion Settings

    @AppStorage("insertionMethod") var insertionMethod: InsertionMethod = .auto

    // MARK: - Singleton

    static let shared = AppSettings()

    private init() {}
}

// MARK: - Enums

enum RecordingMode: String, CaseIterable, Identifiable {
    case hold = "hold"
    case toggle = "toggle"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hold: return "Hold to Record"
        case .toggle: return "Toggle Recording"
        }
    }

    var description: String {
        switch self {
        case .hold: return "Press and hold the hotkey to record, release to stop"
        case .toggle: return "Press once to start recording, press again to stop"
        }
    }
}

enum InsertionMethod: String, CaseIterable, Identifiable {
    case auto = "auto"
    case direct = "direct"
    case clipboard = "clipboard"
    case typing = "typing"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .auto: return "Automatic (Recommended)"
        case .direct: return "Direct Accessibility API"
        case .clipboard: return "Clipboard Paste"
        case .typing: return "Simulated Typing"
        }
    }

    var description: String {
        switch self {
        case .auto: return "Try direct insertion, fall back to clipboard, then typing"
        case .direct: return "Insert text directly via Accessibility API"
        case .clipboard: return "Copy to clipboard and paste with Cmd+V"
        case .typing: return "Type each character individually"
        }
    }
}

// MARK: - Language Support

extension AppSettings {
    /// Supported languages for speech recognition
    static let supportedLanguages: [(code: String, name: String)] = [
        ("en-US", "English (United States)"),
        ("en-GB", "English (United Kingdom)"),
        ("en-AU", "English (Australia)"),
        ("en-CA", "English (Canada)"),
        ("es-ES", "Spanish (Spain)"),
        ("es-MX", "Spanish (Mexico)"),
        ("fr-FR", "French (France)"),
        ("fr-CA", "French (Canada)"),
        ("de-DE", "German (Germany)"),
        ("it-IT", "Italian (Italy)"),
        ("pt-BR", "Portuguese (Brazil)"),
        ("pt-PT", "Portuguese (Portugal)"),
        ("ja-JP", "Japanese"),
        ("ko-KR", "Korean"),
        ("zh-CN", "Chinese (Simplified)"),
        ("zh-TW", "Chinese (Traditional)"),
        ("zh-HK", "Chinese (Hong Kong)"),
        ("ru-RU", "Russian"),
        ("ar-SA", "Arabic"),
        ("nl-NL", "Dutch"),
        ("sv-SE", "Swedish"),
        ("da-DK", "Danish"),
        ("fi-FI", "Finnish"),
        ("no-NO", "Norwegian"),
        ("pl-PL", "Polish"),
        ("tr-TR", "Turkish"),
        ("th-TH", "Thai"),
        ("id-ID", "Indonesian"),
        ("vi-VN", "Vietnamese"),
        ("he-IL", "Hebrew"),
    ]

    /// Get display name for current language
    var currentLanguageName: String {
        Self.supportedLanguages.first { $0.code == recognitionLanguage }?.name ?? recognitionLanguage
    }
}

// MARK: - AppStorage Extensions for Custom Types

extension RecordingMode: RawRepresentable {
    // Already RawRepresentable via String
}

extension InsertionMethod: RawRepresentable {
    // Already RawRepresentable via String
}
