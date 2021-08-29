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
    //private let mailNotifier = MailNotifier()
    private let icloudNotifier = iCloudNotifier()
    private var dropboxNotifier = DropboxNotifier()
    
    private var settings: SettingsDto?
    
    func setupSettings(settings: SettingsDto?) {
        self.settings = settings
        
        dropboxNotifier.register(with: settings)
    }
        
    func send(_ thiefDto: ThiefDto) -> Bool {
        var result = false
        
        //if settings?.isSendNotificationToMail == true, let mail = settings?.mailRecipient {
            //result = mailNotifier.send(thiefDto, to: mail)
        //}
        
        if settings?.isICloudSyncEnable == true {
            result = icloudNotifier.send(thiefDto)
        }
        
        if settings?.isDropboxEnable == true {
            result = dropboxNotifier.send(thiefDto)
        }
        
        return result
    }
}
