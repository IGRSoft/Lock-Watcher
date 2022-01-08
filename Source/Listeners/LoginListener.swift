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
    
    private lazy var debouncedThief: () -> Void = {
        let debouncedFunction = DispatchQueue.main.debounce(interval: 500) { [weak self] in
            let thief = ThiefDto()
            thief.trigerType = .logedIn
                        
            self?.listenerAction?(thief)
        }
        
        return debouncedFunction
    }()
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "LoginListener started")
        isRunning = true
        listenerAction = action
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.sessionDidBecomeActiveNotification(_:)),
                                                   name: NSWindow.didChangeOcclusionStateNotification,
                                                   object: nil)
        }
    }
    
    func stop() {
        os_log(.debug, "LoginListener stoped")
        isRunning = false
        listenerAction = nil
        
        NotificationCenter.default.removeObserver(self, name: NSWindow.didChangeOcclusionStateNotification, object: nil)
    }
    
    @objc func sessionDidBecomeActiveNotification(_ notification: Notification) {
        os_log(.debug, "LoginListener didChangeOcclusionStateNotification")
        
        guard let window = (notification.object as? NSWindow) else {
            return
        }
        
        if window.occlusionState.contains(.visible) {
            debouncedThief()
        }
    }
}
