//
//  NotificationManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import AppKit
import CoreLocation
import Foundation

/// This protocol outlines the responsibilities and interface of the `NotificationManager` class.
protocol NotificationManagerProtocol {
    /// Send a notification based on the provided `ThiefDto` object.
    func send(_ thiefDto: ThiefDto) -> Bool
    
    /// Complete the Dropbox authentication process.
    func completeDropboxAuthWith(url: URL, completionHandler handler: @escaping Commons.StringClosure)
}

/// The main class that orchestrates the sending of notifications through various channels.
final class NotificationManager: NotificationManagerProtocol {
    // MARK: - Dependency injection
    
    /// The manager uses settings to configure its behavior.
    private var settings: AppSettingsProtocol
    
    // MARK: - Variables
    
    /// Different notifiers to send notifications through various channels.
    private lazy var mailNotifier: NotifierProtocol = MailNotifier()
    private lazy var iCloudNotifier: NotifierProtocol = ICloudNotifier()
    private lazy var dropboxNotifier: NotifierProtocol = DropboxNotifier()
    private lazy var notificationNotifier: NotifierProtocol = NotificationNotifier()
    
    // MARK: - initialiser
    
    /// The manager is initialized with the given settings and registers some notifiers with these settings.
    init(settings: AppSettingsProtocol) {
        self.settings = settings
        
        mailNotifier.register(with: settings)
        dropboxNotifier.register(with: settings)
    }
    
    // MARK: - public
    
    /// Sends a notification through one or more channels based on the provided `ThiefDto` object.
    func send(_ thiefDto: ThiefDto) -> Bool {
        var result = false
        
        // Checks various conditions based on settings and sends notifications accordingly:
        
        // If the build isn't a Mac App Store build, and mail notifications are enabled and a mail recipient exists:
        let mail = settings.sync.mailRecipient
        if AppSettings.isMASBuild == false, settings.sync.isSendNotificationToMail, !mail.isEmpty {
            result = mailNotifier.send(thiefDto)
        }
        
        // If iCloud sync is enabled:
        if settings.sync.isICloudSyncEnable {
            result = iCloudNotifier.send(thiefDto)
        }
        
        // If Dropbox sync is enabled:
        if settings.sync.isDropboxEnable {
            result = dropboxNotifier.send(thiefDto)
        }
        
        // If local snapshot notifications are enabled:
        if settings.sync.isUseSnapshotLocalNotification {
            result = notificationNotifier.send(thiefDto)
        }
        
        return result
    }
    
    /// Completes the Dropbox authentication process.
    func completeDropboxAuthWith(url: URL, completionHandler handler: @escaping Commons.StringClosure) {
        guard let dropboxNotifier = dropboxNotifier as? DropboxNotifierProtocol else {
            return
        }
        
        dropboxNotifier.completeDropboxAuthWith(url: url, completionHandler: handler)
    }
}
