//
//  TextInsertionManager.swift
//  LocalDictation
//
//  Manages text insertion into focused UI elements using Accessibility API
//

import Cocoa
import ApplicationServices

/// Errors that can occur during text insertion
enum TextInsertionError: Error {
    case noFocusedElement
    case unsupportedElement
    case insertionFailed
    case accessibilityPermissionDenied
}

/// Manages inserting transcribed text into the active application
/// Uses a fallback chain: direct Accessibility API → clipboard paste → keystroke simulation
class TextInsertionManager {

    // MARK: - Properties

    /// Singleton instance
    static let shared = TextInsertionManager()

    private init() {
        print("[TextInsertionManager] Initialized")
    }

    // MARK: - Accessibility API Basics

    /// Gets the currently focused UI element from the system
    /// - Returns: The focused AXUIElement, or nil if none is focused
    func getFocusedElement() -> AXUIElement? {
        let systemWide = AXUIElementCreateSystemWide()
        var focusedElement: CFTypeRef?

        let result = AXUIElementCopyAttributeValue(
            systemWide,
            kAXFocusedUIElementAttribute as CFString,
            &focusedElement
        )

        if result == .success, let element = focusedElement {
            print("[TextInsertionManager] Successfully retrieved focused element")
            return (element as! AXUIElement)
        } else {
            print("[TextInsertionManager] Failed to get focused element: \(result.rawValue)")
            return nil
        }
    }

    /// Reads the current text value from an AXUIElement
    /// - Parameter element: The UI element to read from
    /// - Returns: The current text value, or nil if unavailable
    func getCurrentText(from element: AXUIElement) -> String? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            element,
            kAXValueAttribute as CFString,
            &value
        )

        if result == .success {
            let text = value as? String
            print("[TextInsertionManager] Current text: \(text ?? "nil")")
            return text
        } else {
            print("[TextInsertionManager] Failed to read text: \(result.rawValue)")
            return nil
        }
    }

    // MARK: - Text Insertion Methods

    /// Public method for direct text insertion (finds focused element automatically)
    /// - Parameter text: The text to insert
    /// - Throws: TextInsertionError if insertion fails
    func insertTextDirect(_ text: String) throws {
        print("[TextInsertionManager] Attempting direct insertion: \"\(text)\"")

        // Check accessibility permission
        guard AXIsProcessTrusted() else {
            print("[TextInsertionManager] ❌ Accessibility permission not granted")
            throw TextInsertionError.accessibilityPermissionDenied
        }

        // Get focused element
        guard let focusedElement = getFocusedElement() else {
            print("[TextInsertionManager] ❌ No focused element found")
            throw TextInsertionError.noFocusedElement
        }

        // Attempt direct insertion
        if !insertTextDirect(text, to: focusedElement) {
            print("[TextInsertionManager] ❌ Direct insertion failed")
            throw TextInsertionError.insertionFailed
        }

        print("[TextInsertionManager] ✅ Direct insertion succeeded")
    }

    /// Attempts direct text insertion via Accessibility API (internal)
    /// - Parameters:
    ///   - text: The text to insert
    ///   - element: The target UI element
    /// - Returns: True if insertion succeeded
    private func insertTextDirect(_ text: String, to element: AXUIElement) -> Bool {
        print("[TextInsertionManager] Attempting direct insertion to element")

        // Try to set the value directly
        let result = AXUIElementSetAttributeValue(
            element,
            kAXValueAttribute as CFString,
            text as CFTypeRef
        )

        if result == .success {
            print("[TextInsertionManager] ✅ Direct insertion to element succeeded")
            return true
        } else {
            print("[TextInsertionManager] ❌ Direct insertion to element failed: \(result.rawValue)")
            return false
        }
    }

    /// Inserts text via clipboard (Cmd+V simulation)
    /// - Parameter text: The text to insert
    func insertViaClipboard(_ text: String) {
        print("[TextInsertionManager] Attempting clipboard insertion: \"\(text)\"")

        let pasteboard = NSPasteboard.general

        // Save old clipboard content
        let oldContent = pasteboard.string(forType: .string)

        // Set new content
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)

        // Simulate Cmd+V
        simulateKeyPress(keyCode: 9, modifiers: .maskCommand) // V key

        // Restore old clipboard after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let oldContent = oldContent {
                pasteboard.clearContents()
                pasteboard.setString(oldContent, forType: .string)
                print("[TextInsertionManager] Restored previous clipboard content")
            }
            print("[TextInsertionManager] ✅ Clipboard insertion completed")
        }
    }

    /// Inserts text by simulating individual keystrokes
    /// - Parameter text: The text to insert
    func insertViaKeystrokes(_ text: String) {
        print("[TextInsertionManager] Attempting keystroke insertion: \"\(text)\"")

        for character in text {
            simulateCharacter(character)
            Thread.sleep(forTimeInterval: 0.01) // Small delay between keystrokes
        }

        print("[TextInsertionManager] ✅ Keystroke insertion completed")
    }

    /// Main insertion method with automatic fallback chain
    /// - Parameter text: The text to insert
    /// - Throws: TextInsertionError if all methods fail
    func insertText(_ text: String) throws {
        print("[TextInsertionManager] === Starting text insertion ===")
        print("[TextInsertionManager] Text to insert: \"\(text)\"")

        // Check accessibility permission
        guard AXIsProcessTrusted() else {
            print("[TextInsertionManager] ❌ Accessibility permission not granted")
            throw TextInsertionError.accessibilityPermissionDenied
        }

        // Method 1: Direct Accessibility API insertion
        if let focusedElement = getFocusedElement() {
            if insertTextDirect(text, to: focusedElement) {
                print("[TextInsertionManager] === Insertion complete (method: direct) ===")
                return
            }
        } else {
            print("[TextInsertionManager] ⚠️ No focused element found")
        }

        // Method 2: Clipboard fallback
        print("[TextInsertionManager] Falling back to clipboard method")
        insertViaClipboard(text)
        print("[TextInsertionManager] === Insertion complete (method: clipboard) ===")

        // Note: We don't throw an error for clipboard method since it's async
        // and we can't immediately verify success
    }

    // MARK: - Helper Methods

    /// Simulates a key press with optional modifiers
    /// - Parameters:
    ///   - keyCode: The virtual key code to press
    ///   - modifiers: Optional modifier flags (Cmd, Shift, etc.)
    private func simulateKeyPress(keyCode: CGKeyCode, modifiers: CGEventFlags = []) {
        let keyDown = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: nil, virtualKey: keyCode, keyDown: false)

        keyDown?.flags = modifiers
        keyUp?.flags = modifiers

        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
    }

    /// Simulates typing a single character
    /// - Parameter character: The character to type
    private func simulateCharacter(_ character: Character) {
        let string = String(character)

        // Create a keyboard event with the character
        if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true) {
            let utf16 = Array(string.utf16)
            event.keyboardSetUnicodeString(stringLength: utf16.count, unicodeString: utf16)
            event.post(tap: .cghidEventTap)
        }

        if let event = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false) {
            let utf16 = Array(string.utf16)
            event.keyboardSetUnicodeString(stringLength: utf16.count, unicodeString: utf16)
            event.post(tap: .cghidEventTap)
        }
    }
}
