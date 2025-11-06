//
//  LocalDictationApp.swift
//  LocalDictation
//
//  Main application entry point for the Local Dictation macOS app
//

import SwiftUI

@main
struct LocalDictationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.automatic)
        .windowResizability(.contentSize)
    }
}