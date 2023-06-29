//
//  NotificationManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import AppKit
import CoreLocation

class NotificationManager {
    private lazy var mailNotifier = MailNotifier()
    private lazy var icloudNotifier = iCloudNotifier()
    private lazy var dropboxNotifier = DropboxNotifier()
    private lazy var notificationNotifier = NotificationNotifier()
    private weak var settings: (any AppSettingsProtocol)!
    
    init(settings: any AppSettingsProtocol) {
        self.settings = settings
        
        dropboxNotifier.register(with: settings)
    }
    
    func send(_ thiefDto: ThiefDto) -> Bool {
        var result = false
        
        let mail = settings.sync.mailRecipient
        if AppSettings.isMASBuild == false, settings.sync.isSendNotificationToMail, !mail.isEmpty {
            result = mailNotifier.send(thiefDto, to: mail)
        }
        
        if settings.sync.isICloudSyncEnable {
            result = icloudNotifier.send(thiefDto)
        }
        
        if settings.sync.isDropboxEnable {
            result = dropboxNotifier.send(thiefDto)
        }
        
        if settings.sync.isUseSnapshotLocalNotification {
            result = notificationNotifier.send(thiefDto)
        }
        
        return result
    }
}
