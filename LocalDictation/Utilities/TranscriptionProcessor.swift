//
//  TranscriptionProcessor.swift
//  LocalDictation
//
//  Utility for processing and cleaning up transcribed text
//

import Foundation

class TranscriptionProcessor {
    static let shared = TranscriptionProcessor()

    private init() {}

    /// Common filler words to remove from transcription
    private let fillerWords: Set<String> = [
        "um", "uh", "uhm", "umm",
        "er", "err", "ah", "ahh",
        "like", // Only when used as filler
        "you know",
        "i mean",
        "sort of", "kind of",
        "basically",
        "actually", // When overused as filler
        "literally", // When misused as filler
        "so", // When used as filler at start
        "well", // When used as filler at start
    ]

    /// Process transcribed text to remove filler words and clean up
    func processTranscription(_ text: String) -> String {
        var processed = text

        // Remove filler words (case-insensitive)
        for fillerWord in fillerWords {
            // Match whole words only, not parts of words
            let pattern = "\\b\(fillerWord)\\b"
            if let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) {
                let range = NSRange(location: 0, length: processed.utf16.count)
                processed = regex.stringByReplacingMatches(
                    in: processed,
                    options: [],
                    range: range,
                    withTemplate: ""
                )
            }
        }

        // Clean up multiple spaces
        processed = processed.replacingOccurrences(of: "  +", with: " ", options: .regularExpression)

        // Clean up space before punctuation
        processed = processed.replacingOccurrences(of: " ([,.!?;:])", with: "$1", options: .regularExpression)

        // Clean up spaces at start and end
        processed = processed.trimmingCharacters(in: .whitespacesAndNewlines)

        // Fix capitalization after periods
        processed = capitalizeAfterPeriods(processed)

        return processed
    }

    /// Capitalize first letter after periods
    private func capitalizeAfterPeriods(_ text: String) -> String {
        var result = text
        var shouldCapitalize = true // Capitalize first word

        for (index, char) in text.enumerated() {
            if shouldCapitalize && char.isLetter {
                let stringIndex = text.index(text.startIndex, offsetBy: index)
                result.replaceSubrange(stringIndex...stringIndex, with: String(char.uppercased()))
                shouldCapitalize = false
            }

            if char == "." || char == "!" || char == "?" {
                shouldCapitalize = true
            }
        }

        return result
    }

    /// Remove specific filler words more aggressively
    /// For phrases like "you know" at the beginning or end of sentences
    func removeFillerPhrases(_ text: String) -> String {
        var processed = text

        // Remove "you know" at start or end of sentences
        processed = processed.replacingOccurrences(of: "^you know,?\\s*", with: "", options: [.regularExpression, .caseInsensitive])
        processed = processed.replacingOccurrences(of: ",?\\s*you know$", with: "", options: [.regularExpression, .caseInsensitive])

        // Remove "I mean" at start
        processed = processed.replacingOccurrences(of: "^i mean,?\\s*", with: "", options: [.regularExpression, .caseInsensitive])

        // Remove "like" when used as filler (tricky - only certain contexts)
        // e.g., "it's like really good" -> "it's really good"
        processed = processed.replacingOccurrences(of: "\\s+like\\s+(really|very|so|totally)", with: " $1", options: [.regularExpression, .caseInsensitive])

        return processed
    }

    /// Full processing pipeline
    func cleanTranscription(_ text: String, removeFiller: Bool = true) -> String {
        guard !text.isEmpty else { return text }

        var cleaned = text

        if removeFiller {
            // First pass: remove filler phrases
            cleaned = removeFillerPhrases(cleaned)

            // Second pass: remove individual filler words
            cleaned = processTranscription(cleaned)
        } else {
            // Just clean up spacing and capitalization
            cleaned = processTranscription(cleaned)
        }

        return cleaned
    }
}
