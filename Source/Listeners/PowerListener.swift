//
//  PowerListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

/// Listen power xpc service on power status changes
/// 
class PowerListener: BaseListenerProtocol {
    
    //MARK: - Types
    
    private enum PowerMode: Int {
        case battery = 0
        case ac = 1
    }
    
    //MARK: - Dependency injection
    
    private let logger: Log
    
    //MARK: - Variables
    
    private let kServiceName = "com.igrsoft.XPCPower"
    
    var listenerAction: ListenerAction?
    
    var isRunning = false
    
    private lazy var connection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCPowerProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = { [weak self] in
            self?.logger.error("XPCPower interrupted")
        }
        
        connection.invalidationHandler = { [weak self] in
            self?.logger.error("XPCPower invalidated")
        }
        
        return connection
    }()
    
    private lazy var service: XPCPowerProtocol = {
        let service = connection.remoteObjectProxyWithErrorHandler { [weak self] error in
            self?.logger.error("Received error: \(error.localizedDescription)")
        } as! XPCPowerProtocol
        
        return service
    }()
    
    //MARK: - initialiser
    
    init(logger: Log = Log(category: .powerListener)) {
        self.logger = logger
    }
    
    deinit {
        connection.invalidate()
    }
    
    //MARK: - public
    
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        self.listenerAction = action
        
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
    
    func stop() {
        self.listenerAction = nil
        (connection.remoteObjectProxy as? XPCPowerProtocol)?.stopCheckPower()
        
        logger.debug("stoped")
        
        isRunning = false
    }
}
