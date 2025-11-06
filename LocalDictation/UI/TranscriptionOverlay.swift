//
//  TranscriptionOverlay.swift
//  LocalDictation
//
//  Floating overlay window that shows real-time transcription
//

import SwiftUI
import AppKit

class TranscriptionOverlayWindow: NSWindow {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 150),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        // Window configuration
        self.isOpaque = false
        self.backgroundColor = .clear
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .stationary]
        self.hasShadow = true
        self.isMovableByWindowBackground = false

        // Position near cursor
        positionNearCursor()
    }

    func positionNearCursor() {
        if let screen = NSScreen.main {
            let mouseLocation = NSEvent.mouseLocation
            var x = mouseLocation.x + 20
            var y = mouseLocation.y - self.frame.height - 20

            // Ensure window stays on screen
            let maxX = screen.frame.maxX - self.frame.width - 20
            let minY = screen.frame.minY + 20

            if x > maxX {
                x = mouseLocation.x - self.frame.width - 20
            }

            if y < minY {
                y = mouseLocation.y + 20
            }

            self.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
}

struct TranscriptionOverlayView: View {
    @ObservedObject var controller: TranscriptionOverlayController

    var body: some View {
        VStack(spacing: 12) {
            // Recording indicator
            HStack(spacing: 8) {
                // Animated recording dot
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .opacity(controller.isRecording ? 1.0 : 0.0)
                    .animation(
                        controller.isRecording ?
                        Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true) :
                            .default,
                        value: controller.isRecording
                    )

                Text("Listening...")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()
            }

            Divider()
                .background(Color.white.opacity(0.3))

            // Transcription text
            ScrollView {
                Text(controller.transcriptionText.isEmpty ? "Start speaking..." : controller.transcriptionText)
                    .font(.body)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
            }
            .frame(maxHeight: 80)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.85))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .padding(8)
    }
}

class TranscriptionOverlayController: ObservableObject {
    private var window: TranscriptionOverlayWindow?
    @Published var transcriptionText: String = ""
    @Published var isRecording: Bool = false

    func show() {
        guard window == nil else { return }

        let overlayView = TranscriptionOverlayView(controller: self)

        let hostingController = NSHostingController(rootView: overlayView)
        hostingController.view.frame = NSRect(x: 0, y: 0, width: 400, height: 150)

        window = TranscriptionOverlayWindow()
        window?.contentView = hostingController.view
        window?.orderFrontRegardless()
        window?.makeKey()

        isRecording = true

        print("[TranscriptionOverlay] Overlay shown")
    }

    func hide() {
        isRecording = false

        // Fade out animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.window?.orderOut(nil)
            self.window?.close()
            self.window = nil
            print("[TranscriptionOverlay] Overlay hidden")
        }
    }

    func updateText(_ text: String) {
        transcriptionText = text
    }
}

#Preview {
    let controller = TranscriptionOverlayController()
    controller.transcriptionText = "This is a sample transcription that will appear in real-time as you speak."
    controller.isRecording = true
    return TranscriptionOverlayView(controller: controller)
        .frame(width: 400, height: 150)
}
