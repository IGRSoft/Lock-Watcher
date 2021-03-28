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
    private let mailNotifier = MailNotifier()
    
    private var settings: SettingsDto?
    
    func setupSettings(settings: SettingsDto) {
        self.settings = settings
    }
    
    func send(photo path: String?, coordinate: CLLocationCoordinate2D) -> Bool {
        var result = false
        
        if settings?.isSendNotificationToMail == true, let mail = settings?.mailRecipient {
            result = mailNotifier.send(photo: path, to: mail, coordinate: coordinate)
        }
        
        return result
    }
}
