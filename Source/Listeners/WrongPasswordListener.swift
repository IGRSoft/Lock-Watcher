//
//  WrongPasswordListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import LocalAuthentication
import os
import AppKit

class WrongPasswordListener: BaseListener, BaseListenerProtocol {
    private let kServiceName = "com.igrsoft.XPCAuthentication"
    
    var listenerAction: ListenerAction?
    
    var isRunning = false
    var isScreenLocked = false
    
    var lastScreenLockDate = Date()
    
    deinit {
        connection.invalidate()
    }
    
    private lazy var connection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCAuthenticationProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = {
            os_log(.error, "Service XPCAuthentication interupted")
        }
        
        connection.invalidationHandler = {
            os_log(.error, "Service XPCAuthentication invalidated")
        }
        
        return connection
    }()
    
    private lazy var service: XPCAuthenticationProtocol = {
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            os_log(.error, "Received error: \(error.localizedDescription)")
        } as! XPCAuthenticationProtocol
        
        return service
    }()
    
    @objc private func occlusionStateChanged() {
        if NSApp.occlusionState.contains(.visible) {
            os_log(.debug, "WrongPasswordListener screen unlocked")
            isScreenLocked = false
        } else {
            os_log(.debug, "WrongPasswordListener screen locked")
            
            lastScreenLockDate = Date()
            isScreenLocked = true
            
            readDate()
        }
    }
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "WrongPasswordListener started")
        
        self.listenerAction = action
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(occlusionStateChanged),
                                               name: NSApplication.didChangeOcclusionStateNotification,
                                               object: nil)
        
        isRunning = true
    }
    
    func readDate() {
        os_log(.debug, "WrongPasswordListener detecting AuthenticationFailed from \(self.lastScreenLockDate)")
        
        service.detectedAuthenticationFailedFromDate(lastScreenLockDate) { [weak self] (detectedFailed) in
            let thief = ThiefDto()
            
            if detectedFailed {
                self?.lastScreenLockDate = Date()
                os_log(.debug, "Detected Authentication Failed")
                thief.triggerType = .onWrongPassword
            }
            
            DispatchQueue.main.async {
                self?.listenerAction?(.onWrongPassword, thief)
            }
        }
    }
    
    func stop() {
        self.listenerAction = nil
        
        NotificationCenter.default.removeObserver(self, name: NSApplication.didChangeOcclusionStateNotification, object: nil)
        
        os_log(.debug, "WrongPasswordListener stoped")
        
        isRunning = false
    }
}
