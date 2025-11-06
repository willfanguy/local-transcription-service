//
//  LocalDictationApp.swift
//  LocalDictation
//
//  Main application entry point for the Local Dictation macOS app
//

import SwiftUI

@main
struct LocalDictationApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // Menu bar app - no default window
        Settings {
            EmptyView()
        }
    }
}