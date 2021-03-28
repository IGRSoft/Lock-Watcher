//
//  PowerListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import os

class PowerListener: BaseListener, BaseListenerProtocol {
    enum PowerMode : Int {
        case battery = 0
        case ac = 1
    }
    
    private let kServiceName = "com.igrsoft.XPCPower"
    
    var listenerAction: ListenerAction?
    
    var isRunning = false
    
    private var connection: NSXPCConnection?
    
    private var service: XPCPowerProtocol {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCPowerProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = {
            os_log(.error, "Service XPCPower interupted")
        }
        
        connection.invalidationHandler = {
            os_log(.error, "Service XPCPower invalidated")
        }
        
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            os_log(.error, "Received error: \(error.localizedDescription)")
        } as! XPCPowerProtocol
        
        self.connection = connection
        
        return service
    }
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "PowerListener started")
        
        self.listenerAction = action
        
        service.startCheckPower { [weak self] mode in
            self?.isRunning = false
            
            let powerMode = PowerMode.init(rawValue: mode)
            os_log(.debug, "Power switched to \(powerMode == .battery ? "Battery" : "AC Power")")
            
            let thief = ThiefDto()
            if powerMode == .battery {
                thief.trigerType = .onBatteryPower
            }
            
            self?.listenerAction?(thief)
        }
        
        isRunning = true
    }
    
    func stop() {
        self.listenerAction = nil
        (connection?.remoteObjectProxy as? XPCPowerProtocol)?.stopCheckPower()
        connection?.invalidate()
        
        os_log(.debug, "PowerListener stoped")
        
        isRunning = false
    }
}
