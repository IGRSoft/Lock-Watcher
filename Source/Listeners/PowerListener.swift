//
//  PowerListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import os

class PowerListener: BaseListener, BaseListenerProtocol {
    enum PowerMode: Int {
        case battery = 0
        case ac = 1
    }
    
    private let kServiceName = "com.igrsoft.XPCPower"
    
    var listenerAction: ListenerAction?
    
    var isRunning = false
    
    deinit {
        connection.invalidate()
    }
    
    private lazy var connection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCPowerProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = {
            os_log(.error, "Service XPCPower interupted")
        }
        
        connection.invalidationHandler = {
            os_log(.error, "Service XPCPower invalidated")
        }
        
        return connection
    }()
    
    private lazy var service: XPCPowerProtocol  = {
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            os_log(.error, "Received error: \(error.localizedDescription)")
        } as! XPCPowerProtocol
                
        return service
    }()
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "PowerListener started")
        
        self.listenerAction = action
        
        service.startCheckPower { [weak self] mode in
            let powerMode = PowerMode.init(rawValue: mode)
            os_log(.debug, "Power switched to \(powerMode == .battery ? "Battery" : "AC Power")")
            
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
        
        os_log(.debug, "PowerListener stoped")
        
        isRunning = false
    }
}
