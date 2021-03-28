//
//  WrongPasswordListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import LocalAuthentication
import os

class WrongPasswordListener: BaseListener, BaseListenerProtocol {
    private let kServiceName = "com.igrsoft.XPCAuthentication"
    
    var listenerAction: ListenerAction?
    
    var isRunning = false
    var isScreenLocked = false
    
    var lastLoginDate = Date()
    
    private var connection: NSXPCConnection?
    
    private var service: XPCAuthenticationProtocol {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCAuthenticationProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = {
            os_log(.error, "Service XPCAuthentication interupted")
        }
        
        connection.invalidationHandler = {
            os_log(.error, "Service XPCAuthentication invalidated")
        }
        
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            os_log(.error, "Received error: \(error.localizedDescription)")
        } as! XPCAuthenticationProtocol
        
        self.connection = connection
        
        return service
    }
    
    override init() {
        super.init()
        
        let nc = DistributedNotificationCenter.default()
        nc.addObserver(self, selector: #selector(screenLocked(_:)) , name: Constants.kScreenLockedNotificationName, object: nil)
        nc.addObserver(self, selector: #selector(screenUnlocked(_:)) , name: Constants.kScreenUnlockedNotificationName, object: nil)
    }
    
    @objc private func screenLocked(_ sender: AnyObject?) {
        lastLoginDate = Date()
        isScreenLocked = true
    }
    
    @objc private func screenUnlocked(_ sender: AnyObject?) {
        isScreenLocked = false
    }
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "WrongPasswordListener started")
        
        self.listenerAction = action
        
        readDate()
        
        isRunning = true
    }
    
    func readDate() {
        if isScreenLocked {
            service.detectedAuthenticationFailedFromDate(lastLoginDate) { [weak self] (detectedFailed) in
                self?.isRunning = false
                
                if detectedFailed {
                    self?.lastLoginDate = Date()
                    os_log(.debug, "Detected Authentication Failed")
                    let thief = ThiefDto()
                    thief.trigerType = .onWrongPassword
                    
                    self?.listenerAction?(thief)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.readDate()
                }
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.readDate()
            }
        }
    }
    
    func stop() {
        self.listenerAction = nil
        (connection?.remoteObjectProxy as? XPCPowerProtocol)?.stopCheckPower()
        connection?.invalidate()
        
        os_log(.debug, "WrongPasswordListener stoped")
        
        isRunning = false
    }
}
