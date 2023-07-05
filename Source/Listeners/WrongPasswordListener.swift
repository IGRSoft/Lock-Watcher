//
//  WrongPasswordListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import AppKit
import LocalAuthentication

/// Check unauthorised login and trigger
/// 
class WrongPasswordListener: BaseListenerProtocol {
    //MARK: - Dependency injection
    
    private let logger: Log
    
    //MARK: - Variables
    
    private let kServiceName = "com.igrsoft.XPCAuthentication"
    
    var listenerAction: ListenerAction?
    
    var isRunning = false
    var isScreenLocked = false
    
    var lastScreenLockDate = Date()
    
    private lazy var connection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCAuthenticationProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = { [weak self] in
            self?.logger.error("XPCAuthentication interrupted")
        }
        
        connection.invalidationHandler = { [weak self] in
            self?.logger.error("XPCAuthentication invalidated")
        }
        
        return connection
    }()
    
    private lazy var service: XPCAuthenticationProtocol  = { [weak self] in
        let service = self?.connection.remoteObjectProxyWithErrorHandler { error in
            self?.logger.error("Received error: \(error.localizedDescription)")
        } as! XPCAuthenticationProtocol
        
        return service
    }()
    
    //MARK: - initialiser
    
    init(logger: Log = Log(category: .wrongPasswordListener)) {
        self.logger = logger
    }
    
    deinit {
        connection.invalidate()
    }
    
    //MARK: - public
    
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        self.listenerAction = action
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(occlusionStateChanged),
                                               name: NSApplication.didChangeOcclusionStateNotification,
                                               object: nil)
        
        isRunning = true
    }
    
    func stop() {
        self.listenerAction = nil
        
        NotificationCenter.default.removeObserver(self, name: NSApplication.didChangeOcclusionStateNotification, object: nil)
        
        logger.debug("stoped")
                
        isRunning = false
    }
    
    //MARK: - private
    
    private func readDate() {
        logger.debug("WrongPasswordListener detecting AuthenticationFailed from \(self.lastScreenLockDate)")
        
        service.detectedAuthenticationFailedFromDate(lastScreenLockDate) { [weak self] detectedFailed in
            let thief = ThiefDto()
            
            if detectedFailed {
                self?.lastScreenLockDate = Date()
                self?.logger.debug("Detected Authentication Failed")
                thief.triggerType = .onWrongPassword
            }
            
            DispatchQueue.main.async {
                self?.listenerAction?(.onWrongPassword, thief)
            }
        }
    }
    
    @objc private func occlusionStateChanged() {
        if NSApp.occlusionState.contains(.visible) {
            logger.debug("screen unlocked")
            isScreenLocked = false
        } else {
            logger.debug("screen locked")
            
            lastScreenLockDate = Date()
            isScreenLocked = true
            
            readDate()
        }
    }
}
