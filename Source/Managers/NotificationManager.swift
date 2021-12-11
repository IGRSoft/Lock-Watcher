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
    
    private var settings: AppSettings?
    
    func setupSettings(settings: AppSettings?) {
        self.settings = settings
        
        dropboxNotifier.register(with: settings)
    }
        
    func send(_ thiefDto: ThiefDto) -> Bool {
        var result = false
        
        if AppSettings.isMASBuild == false, settings?.isSendNotificationToMail == true, let mail = settings?.mailRecipient {
            result = mailNotifier.send(thiefDto, to: mail)
        }
        
        if settings?.isICloudSyncEnable == true {
            result = icloudNotifier.send(thiefDto)
        }
        
        if settings?.isDropboxEnable == true {
            result = dropboxNotifier.send(thiefDto)
        }
        
        return result
    }
}
