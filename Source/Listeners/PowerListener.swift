//
//  PowerListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

class PowerListener: BaseListener, BaseListenerProtocol {
    enum PowerMode : Int {
        case battery = 0
        case ac = 1
    }
    
    var listenerAction: ListenerAction?
    var connection: NSXPCConnection?
    
    
    var service: XPCPowerProtocol {
        let connection = NSXPCConnection(serviceName: "com.igrsoft.XPCPower")
        connection.remoteObjectInterface = NSXPCInterface(with: XPCPowerProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = {
            print("Service interupted.")
        }
        
        connection.invalidationHandler = {
            print("Service invalidated")
        }
        
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Received error:", error)
        } as? XPCPowerProtocol
        
        self.connection = connection
        
        return service!
    }
    
    var _changesInPowerBlock: ((NSInteger) -> Void)?
    
    func changesInPowerBlock() -> ((NSInteger) -> Void) {
        let callback: ((NSInteger) -> Void) = { [weak self] mode in
            let powerMode = PowerMode.init(rawValue: mode)
            self?.listenerAction?(powerMode == .battery)
            
            print("Power moved to \(powerMode == .battery ? "Battery" : "AC Power")")
        }
        
        return callback
    }
    
    func start(_ action: @escaping ListenerAction) {
        stop()
        
        if settings?.isPowerListeningEnable == true {
            print("PowerListener started")
            
            self.listenerAction = action
            
            service.startCheckPower(self.changesInPowerBlock())
        }
    }
    
    func stop() {
        self.listenerAction = nil
        (connection?.remoteObjectProxy as? XPCPowerProtocol)?.stopCheckPower()
        connection?.invalidate()
    }
}
