//
//  USBListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.08.2021.
//

import Cocoa
import Foundation

/// `USBListener` observes USB mount events on the system and emits events via AsyncStream.
///
/// This class is `@MainActor` isolated through `BaseListenerProtocol` conformance,
/// ensuring all state mutations occur on the main thread.
final class USBListener: NSObject, BaseListenerProtocol {
    // MARK: - Dependency injection

    /// Logger instance used for recording and debugging.
    private let logger: LogProtocol

    // MARK: - Variables

    /// Indicates if the listener is currently monitoring USB mount events.
    private(set) var isRunning: Bool = false

    /// Continuation for the AsyncStream to yield events.
    private var continuation: AsyncStream<ListenerEvent>.Continuation?

    /// NotificationCenter to listen usb events
    private lazy var notificationCenter = NSWorkspace.shared.notificationCenter

    // MARK: - Initializer

    /// Initializes a `USBListener`.
    /// - Parameter logger: An instance of `Log` for logging purposes. Defaults to `.usbListener` category.
    init(logger: LogProtocol = Log(category: .usbListener)) {
        self.logger = logger
    }

    // MARK: - Public Methods

    /// Starts monitoring for USB mount events.
    /// - Returns: An AsyncStream that emits events when USB mount is detected.
    func start() -> AsyncStream<ListenerEvent> {
        logger.debug("started")

        return AsyncStream { continuation in
            self.continuation = continuation
            self.isRunning = true

            self.notificationCenter.addObserver(
                self,
                selector: #selector(self.receiveUSBNotification),
                name: NSWorkspace.didMountNotification,
                object: nil
            )

            continuation.onTermination = { [weak self] _ in
                Task { @MainActor in
                    self?.cleanup()
                }
            }
        }
    }

    /// Stops the listener from monitoring USB mount events.
    func stop() {
        logger.debug("stopped")
        continuation?.finish()
        cleanup()
    }

    // MARK: - Private Methods

    private func cleanup() {
        isRunning = false
        continuation = nil
        notificationCenter.removeObserver(self, name: NSWorkspace.didMountNotification, object: nil)
    }

    /// Handles the USB mount event notification.
    @objc
    private func receiveUSBNotification() {
        continuation?.yield((.onUSBConnectionListener, .usbConnected))
    }
}
