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
    #if NON_MAS_CONFIG
    private let mailNotifier = MailNotifier()
    #endif
    private let icloudNotifier = iCloudNotifier()
    private var dropboxNotifier = DropboxNotifier()
    
    private var settings: AppSettings?
    
    func setupSettings(settings: AppSettings?) {
        self.settings = settings
        
        dropboxNotifier.register(with: settings)
    }
        
    func send(_ thiefDto: ThiefDto) -> Bool {
        var result = false
        
        #if NON_MAS_CONFIG
        if settings?.isSendNotificationToMail == true, let mail = settings?.mailRecipient {
            result = mailNotifier.send(thiefDto, to: mail)
        }
        #endif
        
        if settings?.isICloudSyncEnable == true {
            result = icloudNotifier.send(thiefDto)
        }
        
        if settings?.isDropboxEnable == true {
            result = dropboxNotifier.send(thiefDto)
        }
        
        return result
    }
}
