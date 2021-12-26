//
//  NotificationNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import Foundation
import UserNotifications
import AppKit

class NotificationNotifier: NSObject {
    func send(_ thiefDto: ThiefDto) -> Bool {
        guard let localURL = thiefDto.filepath else {
            assert(false, "wrong file path")
            return false
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    
                    let date = Date.dateFormat.string(from: thiefDto.date)
                    let content = UNMutableNotificationContent()
                    content.title = String(format: NSLocalizedString("SnapshotAt", comment: ""), arguments: [date])
                    content.body = thiefDto.trigerType.info
                    content.sound =  UNNotificationSound.default
                    
                    let attachment = try? UNNotificationAttachment(identifier: UUID().uuidString, url: localURL, options: nil)
                    if let attachment = attachment {
                        content.attachments = [attachment]
                    }
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let request = UNNotificationRequest(identifier: date, content: content, trigger: trigger)
                    
                    notificationCenter.add(request)
                }
            }
        }
        
        return true
    }
}
