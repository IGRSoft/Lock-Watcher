//
//  NotificationNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import Foundation
import UserNotifications
import AppKit

/// Send triggered object to UserNotificationCenter to display on sidebar
///
final class NotificationNotifier: NotifierProtocol {
    
    //MARK: - Dependency injection
        
    private var logger: Log
    
    //MARK: - initialiser
    
    init(logger: Log = .init(category: .notificationNotifier)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    func register(with settings: any AppSettingsProtocol) {
    }
    
    func send(_ thiefDto: ThiefDto) -> Bool {
        guard let localURL = thiefDto.filePath else {
            let msg = "wrong file path"
            logger.error(msg)
            assert(false, msg)
            
            return false
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
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
    
    //MARK: - private
    
    private func createNotification(thiefDto: ThiefDto, at url: URL, to notificationCenter: UNUserNotificationCenter) {
        let date = Date.defaultFormat.string(from: thiefDto.date)
        let content = UNMutableNotificationContent()
        content.title = String(format: NSLocalizedString("SnapshotAt", comment: ""), arguments: [date])
        content.body = thiefDto.triggerType.name
        content.sound =  UNNotificationSound.default
        
        if let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: url, options: nil) {
            content.attachments = [attachment]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: date, content: content, trigger: trigger)
        
        logger.debug("send: \(thiefDto)")
        
        notificationCenter.add(request)
    }
}
