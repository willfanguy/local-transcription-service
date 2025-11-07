//
//  DebugLogger.swift
//  LocalDictation
//
//  Created for autonomous crash debugging
//

import Foundation
import os.log

/// Thread-safe file-based logger for autonomous crash debugging
class DebugLogger {
    static let shared = DebugLogger()

    private let logQueue = DispatchQueue(label: "com.LocalDictation.DebugLogger", qos: .utility)
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    private var currentLogURL: URL?
    private var logFileHandle: FileHandle?
    private let maxLogSize: Int = 10 * 1024 * 1024 // 10MB per file

    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"

        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss.SSSSSS"

        setupLogFile()
    }

    private func setupLogFile() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let logDirectory = documentsPath.appendingPathComponent("LocalDictation/debug_logs")

        // Create directory if needed
        try? FileManager.default.createDirectory(at: logDirectory, withIntermediateDirectories: true)

        // Create new log file
        let timestamp = dateFormatter.string(from: Date())
        let logFileName = "debug_\(timestamp).log"
        currentLogURL = logDirectory.appendingPathComponent(logFileName)

        // Create file and open for writing
        FileManager.default.createFile(atPath: currentLogURL!.path, contents: nil)
        logFileHandle = FileHandle(forWritingAtPath: currentLogURL!.path)

        // Create symlink to latest log
        let latestLogURL = logDirectory.appendingPathComponent("latest.log")
        try? FileManager.default.removeItem(at: latestLogURL)
        try? FileManager.default.createSymbolicLink(at: latestLogURL, withDestinationURL: currentLogURL!)

        // Write header
        writeHeader()
    }

    private func writeHeader() {
        log("=" * 80)
        log("LOCAL DICTATION DEBUG LOG")
        log("Started: \(Date())")
        log("Process ID: \(ProcessInfo.processInfo.processIdentifier)")
        log("System: \(ProcessInfo.processInfo.operatingSystemVersionString)")
        log("=" * 80)
        log("")
    }

    /// Log a message with automatic metadata
    func log(_ message: String,
             file: String = #file,
             function: String = #function,
             line: Int = #line,
             level: LogLevel = .debug) {

        logQueue.async { [weak self] in
            guard let self = self else { return }

            let timestamp = self.timeFormatter.string(from: Date())
            let fileName = URL(fileURLWithPath: file).lastPathComponent
            let threadID = Thread.isMainThread ? "MAIN" : "\(Thread.current.hash)"

            let logEntry = "[\(timestamp)] [\(level.rawValue)] [\(threadID)] \(fileName):\(line) \(function) - \(message)\n"

            // Write to file
            if let data = logEntry.data(using: .utf8),
               let handle = self.logFileHandle {
                handle.write(data)

                // Check file size and rotate if needed
                if let size = try? handle.offset(), size > self.maxLogSize {
                    self.rotateLog()
                }
            }

            // Also log to console for real-time monitoring
            print(logEntry, terminator: "")
        }
    }

    /// Log object lifecycle with memory address
    func logLifecycle(_ object: AnyObject, event: LifecycleEvent, additionalInfo: String = "") {
        let address = Unmanaged.passUnretained(object).toOpaque()
        let className = String(describing: type(of: object))

        let message = "\(event.emoji) \(className) @ \(address) - \(event.rawValue) \(additionalInfo)"
        log(message, level: .info)
    }

    /// Log method entry/exit for tracking flow
    func logMethodEntry(_ method: String, parameters: String = "") {
        log("→ Entering \(method) \(parameters.isEmpty ? "" : "with: \(parameters)")", level: .trace)
    }

    func logMethodExit(_ method: String, result: String = "") {
        log("← Exiting \(method) \(result.isEmpty ? "" : "returning: \(result)")", level: .trace)
    }

    /// Log state changes
    func logStateChange(_ object: String, from oldState: String, to newState: String) {
        log("🔄 \(object) state: \(oldState) → \(newState)", level: .info)
    }

    /// Log errors with stack trace
    func logError(_ error: Error, context: String = "") {
        log("❌ ERROR: \(context) - \(error.localizedDescription)", level: .error)
        log("Stack trace: \(Thread.callStackSymbols.joined(separator: "\n"))", level: .error)
    }

    /// Log timing information
    func logTiming(_ operation: String, start: Date, end: Date = Date()) {
        let duration = end.timeIntervalSince(start) * 1000 // Convert to milliseconds
        log("⏱ \(operation) took \(String(format: "%.2f", duration))ms", level: .info)
    }

    /// Mark important events in the log
    func markEvent(_ event: String) {
        log("", level: .info)
        log("🔔 ========== \(event) ==========", level: .warning)
        log("", level: .info)
    }

    /// Flush logs to disk immediately
    func flush() {
        logQueue.async { [weak self] in
            self?.logFileHandle?.synchronizeFile()
        }
    }

    private func rotateLog() {
        logFileHandle?.closeFile()
        setupLogFile()
        log("Log rotated due to size limit", level: .info)
    }

    /// Get current log file path
    var currentLogPath: String? {
        return currentLogURL?.path
    }

    /// Export all logs to a specific location
    func exportLogs(to url: URL) throws {
        flush()

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let logDirectory = documentsPath.appendingPathComponent("LocalDictation/debug_logs")

        // Create zip or copy all log files
        let logs = try FileManager.default.contentsOfDirectory(at: logDirectory,
                                                               includingPropertiesForKeys: nil,
                                                               options: [.skipsHiddenFiles])
            .filter { $0.pathExtension == "log" && $0.lastPathComponent != "latest.log" }

        // Create export directory
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

        // Copy all logs
        for logFile in logs {
            let destination = url.appendingPathComponent(logFile.lastPathComponent)
            try FileManager.default.copyItem(at: logFile, to: destination)
        }
    }

    enum LogLevel: String {
        case trace = "TRACE"
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARN"
        case error = "ERROR"
    }

    enum LifecycleEvent: String {
        case initialized = "initialized"
        case deinitialized = "deinitialized"
        case retained = "retained"
        case released = "released"

        var emoji: String {
            switch self {
            case .initialized: return "🟢"
            case .deinitialized: return "🔴"
            case .retained: return "⬆️"
            case .released: return "⬇️"
            }
        }
    }
}

// MARK: - Convenience functions

func debugLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    DebugLogger.shared.log(message, file: file, function: function, line: line)
}

func debugLogError(_ error: Error, context: String = "", file: String = #file, function: String = #function, line: Int = #line) {
    DebugLogger.shared.logError(error, context: context)
}

func debugMarkEvent(_ event: String) {
    DebugLogger.shared.markEvent(event)
}

// MARK: - Crash Detection Helper

extension DebugLogger {
    /// Monitor for crashes and save crash context
    func installCrashHandler() {
        NSSetUncaughtExceptionHandler { exception in
            DebugLogger.shared.log("💥 UNCAUGHT EXCEPTION: \(exception)", level: .error)
            DebugLogger.shared.log("Reason: \(exception.reason ?? "unknown")", level: .error)
            DebugLogger.shared.log("Stack trace: \(exception.callStackSymbols.joined(separator: "\n"))", level: .error)
            DebugLogger.shared.flush()
        }

        // Install signal handlers for crashes
        let signals = [SIGABRT, SIGILL, SIGSEGV, SIGFPE, SIGBUS, SIGPIPE, SIGTRAP]

        for signal in signals {
            Darwin.signal(signal) { sig in
                DebugLogger.shared.log("💥 SIGNAL RECEIVED: \(sig)", level: .error)
                DebugLogger.shared.log("Stack trace: \(Thread.callStackSymbols.joined(separator: "\n"))", level: .error)
                DebugLogger.shared.flush()

                // Re-raise to get proper crash report
                Darwin.signal(sig, SIG_DFL)
                Darwin.raise(sig)
            }
        }
    }
}

// MARK: - Helper to multiply string (like Python's "=" * 80)
private func *(lhs: String, rhs: Int) -> String {
    return String(repeating: lhs, count: rhs)
}