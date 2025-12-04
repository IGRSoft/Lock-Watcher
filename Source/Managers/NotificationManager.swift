//
//  NotificationManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import AppKit
import CoreLocation

/// This protocol outlines the responsibilities and interface of the `NotificationManager` class.
protocol NotificationManagerProtocol: Sendable {
    /// Send a notification based on the provided `ThiefDto` object.
    func send(_ thiefDto: ThiefDto) async

    /// Complete the Dropbox authentication process.
    func completeDropboxAuthWith(url: URL) async -> String
}

/// The main class that orchestrates the sending of notifications through various channels.
///
/// - Note: `@unchecked Sendable` is required because:
///   - `AppSettingsProtocol` is not `Sendable` but is only read (never mutated) after initialization
///   - All notifiers are `Sendable` and thread-safe
final class NotificationManager: NotificationManagerProtocol, @unchecked Sendable {
    // MARK: - Dependency injection

    /// The manager uses settings to configure its behavior.
    /// - Note: Read-only after initialization, safe for concurrent access.
    private let settings: AppSettingsProtocol

    // MARK: - Variables

    /// Different notifiers to send notifications through various channels.
    private let mailNotifier: NotifierProtocol = MailNotifier()
    private let iCloudNotifier: NotifierProtocol = ICloudNotifier()
    private let dropboxNotifier: DropboxNotifier = DropboxNotifier()
    private let notificationNotifier: NotifierProtocol = NotificationNotifier()

    // MARK: - initialiser

    /// The manager is initialized with the given settings and registers some notifiers with these settings.
    init(settings: AppSettingsProtocol) {
        self.settings = settings

        mailNotifier.register(with: settings)
        dropboxNotifier.register(with: settings)
    }

    // MARK: - public

    /// Sends a notification through one or more channels based on the provided `ThiefDto` object.
    /// Errors are logged but not propagated - notifications are best-effort.
    func send(_ thiefDto: ThiefDto) async {
        // Send to all enabled channels concurrently
        await withTaskGroup(of: Void.self) { group in
            let mail = settings.sync.mailRecipient
            if !AppSettings.isMASBuild, settings.sync.isSendNotificationToMail, !mail.isEmpty {
                group.addTask {
                    try? await self.mailNotifier.send(thiefDto)
                }
            }

            if settings.sync.isICloudSyncEnable {
                group.addTask {
                    try? await self.iCloudNotifier.send(thiefDto)
                }
            }

            if settings.sync.isDropboxEnable {
                group.addTask {
                    try? await self.dropboxNotifier.send(thiefDto)
                }
            }

            if settings.sync.isUseSnapshotLocalNotification {
                group.addTask {
                    try? await self.notificationNotifier.send(thiefDto)
                }
            }
        }
    }

    /// Completes the Dropbox authentication process.
    /// - Parameter url: The callback URL from Dropbox OAuth.
    /// - Returns: The display name of the authenticated user, or empty string on failure.
    func completeDropboxAuthWith(url: URL) async -> String {
        await dropboxNotifier.completeDropboxAuthWith(url: url)
    }
}
