//
//  NotificationNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import AppKit
import Foundation
@preconcurrency import UserNotifications

/// `NotificationNotifier` is responsible for sending local notifications using the User Notifications framework.
/// These notifications alert the user when certain events (like detecting a potential threat) occur.
final class NotificationNotifier: NotifierProtocol, @unchecked Sendable {
    // MARK: - Dependency injection
    
    /// A logger instance for logging various events and errors.
    private var logger: LogProtocol
    
    // MARK: - Initialiser
    
    /// Initializes a new `NotificationNotifier`.
    ///
    /// - Parameter logger: A logger instance. Defaults to a logger with the category `.notificationNotifier`.
    init(logger: LogProtocol = Log(category: .notificationNotifier)) {
        self.logger = logger
    }
    
    // MARK: - Public methods
    
    /// Registers the notifier with the provided settings.
    /// - Parameter settings: An instance conforming to `AppSettingsProtocol` containing app settings.
    func register(with settings: AppSettingsProtocol) {
        // This method is currently empty and can be populated as needed.
    }
    
    /// Sends a notification based on the provided `ThiefDto`.
    ///
    /// - Parameter thiefDto: An instance containing details about the event.
    /// - Returns: A boolean indicating whether the notification process was started successfully.
    func send(_ thiefDto: ThiefDto) -> Bool {
        guard let localURL = thiefDto.filePath else {
            let msg = "wrong file path"
            logger.error(msg)
            assertionFailure(msg)
            
            return false
        }
        
        // Request user's permission to show notifications.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings { [weak self] settings in
                if settings.authorizationStatus == .authorized {
                    self?.createNotification(thiefDto: thiefDto, at: localURL, to: notificationCenter)
                }
            }
        }
        
        return true
    }
    
    // MARK: - Private helper methods
    
    /// Creates and sends a notification using the provided `ThiefDto` and `UNUserNotificationCenter`.
    ///
    /// - Parameters:
    ///   - thiefDto: An instance containing details about the event.
    ///   - url: The local URL of the snapshot image.
    ///   - notificationCenter: An instance of `UNUserNotificationCenter` to which the notification is to be added.
    private func createNotification(thiefDto: ThiefDto, at url: URL, to notificationCenter: UNUserNotificationCenter) {
        let date = Date.defaultFormat.string(from: thiefDto.date)
        
        let content = UNMutableNotificationContent()
        content.title = String(format: NSLocalizedString("SnapshotAt", comment: ""), arguments: [date])
        content.body = thiefDto.triggerType.name
        content.sound =  UNNotificationSound.default
        
        // Attach the image to the notification if available.
        if let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: url, options: nil) {
            content.attachments = [attachment]
        }
        
        // Set the trigger for the notification.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: date, content: content, trigger: trigger)
        
        logger.debug("send: \(thiefDto)")
        
        // Add the notification request to the notification center.
        notificationCenter.add(request)
    }
}
