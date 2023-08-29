//
//  WrongPasswordListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import AppKit
import LocalAuthentication

/// `WrongPasswordListener` monitors attempts to unlock the screen. When an unauthorized login attempt is detected,
/// a specified action is triggered.
final class WrongPasswordListener: BaseListenerProtocol {
    
    //MARK: - Dependency injection
    
    /// Logger instance for recording and debugging.
    private let logger: LogProtocol
    
    //MARK: - Variables
    
    /// XPC Service name responsible for authentication.
    private let kServiceName = "com.igrsoft.XPCAuthentication"
    
    /// Action to be triggered upon detecting an unauthorized login attempt.
    var listenerAction: ListenerAction?
    
    /// Indicates if the listener is currently running.
    var isRunning = false
    
    /// NotificationCenter to listen Change Occlusion State
    private lazy var notificationCenter = NSWorkspace.shared.notificationCenter
    
    /// Indicates if the screen is currently locked.
    private var isScreenLocked = false
    
    /// The date of the last screen lock event.
    private var lastScreenLockDate = Date()
    
    /// Connection to the XPC Authentication service.
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
    
    /// Proxy to the XPC Authentication service.
    private lazy var service: XPCAuthenticationProtocol  = { [weak self] in
        let service = self?.connection.remoteObjectProxyWithErrorHandler { error in
            self?.logger.error("Received error: \(error.localizedDescription)")
        } as! XPCAuthenticationProtocol
        
        return service
    }()
    
    //MARK: - Initializer
    
    /// Initializes a `WrongPasswordListener`.
    /// - Parameter logger: An instance of `Log` for logging purposes. Defaults to `.wrongPasswordListener` category.
    init(logger: LogProtocol = Log(category: .wrongPasswordListener)) {
        self.logger = logger
    }
    
    /// Deinitializer that invalidates the XPC connection.
    deinit {
        connection.invalidate()
    }
    
    //MARK: - Public Methods
    
    /// Starts the listener to monitor unauthorized login attempts.
    /// - Parameter action: A closure that is called when an unauthorized login attempt is detected.
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        self.listenerAction = action
        
        // Register to observe occlusion state changes.
        notificationCenter.addObserver(self,
                                       selector: #selector(occlusionStateChanged),
                                       name: NSApplication.didChangeOcclusionStateNotification,
                                       object: nil)
        
        isRunning = true
    }
    
    /// Stops the listener from monitoring unauthorized login attempts.
    func stop() {
        self.listenerAction = nil
        
        // Remove the observer for occlusion state changes.
        notificationCenter.removeObserver(self, name: NSApplication.didChangeOcclusionStateNotification, object: nil)
        
        logger.debug("stopped")
        
        isRunning = false
    }
    
    //MARK: - Private Methods
    
    /// Checks for unauthorized login attempts since the last known screen lock date.
    private func readDate() {
        logger.debug("WrongPasswordListener detecting AuthenticationFailed from \(self.lastScreenLockDate)")
        
        // Ask the XPC service if any unauthorized login attempts were detected.
        service.detectedAuthenticationFailedFromDate(lastScreenLockDate) { [weak self] detectedFailed in
            let thief = ThiefDto()
            
            if detectedFailed {
                self?.lastScreenLockDate = Date()
                self?.logger.debug("Detected Authentication Failed")
                thief.triggerType = .onWrongPassword
            }
            
            // Trigger the action on the main queue.
            DispatchQueue.main.async {
                self?.listenerAction?(.onWrongPassword, thief)
            }
        }
    }
    
    /// Listens to the occlusion state changes to determine screen lock/unlock events.
    @objc private func occlusionStateChanged() {
        if NSApp.occlusionState.contains(.visible) {
            logger.debug("screen unlocked")
            isScreenLocked = false
        } else {
            logger.debug("screen locked")
            
            lastScreenLockDate = Date()
            isScreenLocked = true
            
            // Check for unauthorized login attempts.
            readDate()
        }
    }
}
