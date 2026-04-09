# Local Dictation

A macOS menu bar app for system-wide voice dictation using Apple's native Speech framework. Press a hotkey, speak, and transcribed text is inserted directly into whatever app you're using — fully on-device, no cloud services.

## Features

- **Global hotkey** — Fn key (configurable) triggers dictation from anywhere
- **Two recording modes** — hold-to-record or toggle on/off
- **On-device transcription** — uses Apple Speech framework, no data leaves your Mac
- **Real-time overlay** — floating window shows transcription as you speak
- **Smart text insertion** — 3-tier fallback: Accessibility API → clipboard paste → simulated typing
- **Filler word removal** — automatically strips "um", "uh", "like", etc.
- **Automatic punctuation** — Apple Speech adds periods, commas, question marks
- **29 languages** — all languages supported by Apple Speech Recognition
- **Multi-tab settings** — configure hotkey, language, insertion behavior, and more

## Requirements

- macOS 13.0+ (Ventura)
- Xcode 15+ / Swift 5.9+

## Installation

```bash
git clone https://github.com/willfanguy/local-transcription-service.git
cd local-transcription-service
open LocalDictation.xcodeproj
```

Build and run from Xcode (⌘R). The app appears in the menu bar.

## Permissions

The app needs three macOS permissions (it will guide you through setup on first launch):

- **Microphone** — to capture your voice
- **Speech Recognition** — to transcribe audio (on-device)
- **Accessibility** — to insert text into other apps and detect the global hotkey

Grant these in System Settings → Privacy & Security.

## Usage

1. Launch the app — it appears as an icon in the menu bar
2. Press **Fn** (or your configured hotkey) to start dictating
3. Speak naturally — text appears in the floating overlay
4. Release the key (or press again in toggle mode) — text is inserted at your cursor

### Recording Modes

- **Hold to record** (default) — press and hold the hotkey, release to insert
- **Toggle** — press once to start, press again to stop and insert

## Architecture

```
LocalDictation/
  Core/           — SpeechRecognitionManager, AudioEngineManager, HotkeyManager, TextInsertionManager
  UI/             — MenuBarView, TranscriptionOverlay, SettingsView, PermissionsView
  Models/         — AppSettings, TranscriptionSession, HotkeyConfiguration
  Utilities/      — PermissionsManager, TranscriptionProcessor
```

## Known Limitations

- Apple Speech Recognition has an undocumented ~1 minute continuous recognition limit — the app automatically restarts recognition when this is hit
- Text insertion via Accessibility API doesn't work in all apps (falls back to clipboard)

## License

MIT
