//
//  LoginListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.09.2021.
//

import Foundation
import Cocoa
import os

class LoginListener: BaseListener, BaseListenerProtocol {
    var listenerAction: ListenerAction?
    
    var isRunning: Bool = false
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "LoginListener started")
        isRunning = true
        listenerAction = action
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionDidBecomeActiveNotification(_:)),
                                               name: NSApplication.didChangeOcclusionStateNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(activeSpaceDidChangeNotification(_:)),
                                               name: NSWorkspace.sessionDidBecomeActiveNotification,
                                               object: nil)
    }
    
    func stop() {
        os_log(.debug, "LoginListener stoped")
        isRunning = false
        listenerAction = nil
        
        NotificationCenter.default.removeObserver(self, name: NSApplication.didChangeOcclusionStateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSWorkspace.sessionDidBecomeActiveNotification, object: nil)
    }
    
    @objc func sessionDidBecomeActiveNotification(_ notif: Notification) {
        os_log(.debug, "LoginListener didChangeOcclusionStateNotification")
    }
    
    @objc func activeSpaceDidChangeNotification(_ notif: Notification) {
        os_log(.debug, "LoginListener sessionDidBecomeActiveNotification")
        
        let thief = ThiefDto()
        thief.trigerType = .logedIn
                    
        listenerAction?(thief)
    }
}
