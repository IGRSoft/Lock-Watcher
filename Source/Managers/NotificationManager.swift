//
//  NotificationManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import AppKit
import CoreLocation

protocol NotificationManagerProtocol {
    func send(_ thiefDto: ThiefDto) -> Bool
}

/// manage notifiers to send data to it
/// 
class NotificationManager: NotificationManagerProtocol {
    
    //MARK: - Dependency injection
    
    private var settings: any AppSettingsProtocol
    
    //MARK: - Variables
    
    private lazy var mailNotifier: NotifierProtocol = MailNotifier()
    private lazy var icloudNotifier: NotifierProtocol = iCloudNotifier()
    private lazy var dropboxNotifier: NotifierProtocol = DropboxNotifier()
    private lazy var notificationNotifier: NotifierProtocol = NotificationNotifier()
    
    //MARK: - initialiser
    
    init(settings: any AppSettingsProtocol) {
        self.settings = settings
        
        mailNotifier.register(with: settings)
        dropboxNotifier.register(with: settings)
    }
    
    //MARK: - public
    
    func send(_ thiefDto: ThiefDto) -> Bool {
        var result = false
        
        let mail = settings.sync.mailRecipient
        if AppSettings.isMASBuild == false, settings.sync.isSendNotificationToMail, !mail.isEmpty {
            result = mailNotifier.send(thiefDto)
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
