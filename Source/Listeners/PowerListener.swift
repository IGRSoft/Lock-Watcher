//
//  PowerListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

/// `PowerListener` observes power status changes by communicating with an XPC service.
/// This listener can detect when the system switches between battery power and AC power.
final class PowerListener: BaseListenerProtocol {
    
    //MARK: - Types
    
    /// Enumeration representing power modes: Battery or AC.
    private enum PowerMode: Int {
        case battery = 0
        case ac = 1
    }
    
    //MARK: - Dependency injection
    
    /// Logger used for recording and debugging.
    private let logger: Log
    
    //MARK: - Variables
    
    /// The name of the XPC service used to monitor power status.
    private let kServiceName = "com.igrsoft.XPCPower"
    
    /// Action to be called upon detecting a power mode change.
    var listenerAction: ListenerAction?
    
    /// Indicates if the listener is currently monitoring power changes.
    var isRunning = false
    
    /// Connection to the XPC service.
    private lazy var connection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCPowerProtocol.self)
        connection.resume()
        
        // Handles interruptions in the XPC service connection.
        connection.interruptionHandler = { [weak self] in
            self?.logger.error("XPCPower interrupted")
        }
        
        // Handles invalidation of the XPC service connection.
        connection.invalidationHandler = { [weak self] in
            self?.logger.error("XPCPower invalidated")
        }
        
        return connection
    }()
    
    /// Proxy object for the XPC service.
    private lazy var service: XPCPowerProtocol = {
        let service = connection.remoteObjectProxyWithErrorHandler { [weak self] error in
            self?.logger.error("Received error: \(error.localizedDescription)")
        } as! XPCPowerProtocol
        
        return service
    }()
    
    //MARK: - Initializer
    
    /// Initializes a `PowerListener`.
    /// - Parameter logger: An instance of `Log` for logging purposes. Defaults to `.powerListener` category.
    init(logger: Log = Log(category: .powerListener)) {
        self.logger = logger
    }
    
    /// Deinitializer. Invalidates the XPC connection.
    deinit {
        connection.invalidate()
    }
    
    //MARK: - Public Methods
    
    /// Starts monitoring power mode changes.
    /// - Parameter action: A closure that is called when a power mode change is detected.
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        self.listenerAction = action
        
        // Start monitoring power mode through the XPC service.
        service.startCheckPower { [weak self] mode in
            let powerMode = PowerMode.init(rawValue: mode)
            self?.logger.debug("Power switched to \(powerMode == .battery ? "Battery" : "AC Power")")
            
            let thief = ThiefDto()
            if powerMode == .battery {
                thief.triggerType = .onBatteryPower
            }
            
            DispatchQueue.main.async {
                self?.listenerAction?(.onBatteryPowerListener, thief)
            }
        }
        
        isRunning = true
    }
    
    /// Stops the listener from monitoring power mode changes.
    func stop() {
        self.listenerAction = nil
        (connection.remoteObjectProxy as? XPCPowerProtocol)?.stopCheckPower()
        
        logger.debug("stopped")
        
        isRunning = false
    }
}
