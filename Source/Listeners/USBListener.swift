//
//  USBListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.08.2021.
//

import Foundation
import Cocoa
import os

class USBListener: BaseListener, BaseListenerProtocol {
    var listenerAction: ListenerAction?
    
    var isRunning: Bool = false
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "USBListener started")
        isRunning = true
        listenerAction = action
        
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(receiveUSBNotification(_:)),
                                                          name: NSWorkspace.didMountNotification,
                                                          object: nil)
    }
    
    func stop() {
        os_log(.debug, "USBListener stoped")
        isRunning = false
        listenerAction = nil
        
        NSWorkspace.shared.notificationCenter.removeObserver(self, name: NSWorkspace.didMountNotification, object: nil)
    }
    
    @objc func receiveUSBNotification(_ notif: Notification) {
        let thief = ThiefDto()
        thief.trigerType = .usbConnected
                    
        listenerAction?(thief)
    }
}
