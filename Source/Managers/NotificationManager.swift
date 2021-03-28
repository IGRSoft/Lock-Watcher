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
    let mailNotifier = MailNotifier()
    
    func send(photo path: String?, to mail: String, coordinate: CLLocationCoordinate2D) -> Bool {
        return mailNotifier.send(photo: path, to: mail, coordinate: coordinate)
    }
}
