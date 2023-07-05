//
//  main.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.03.2021.
//

import Foundation

final class XPCAuthenticationDelegate: NSObject, NSXPCListenerDelegate {
    
    /// NSXPCListenerDelegate
    /// 
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        let exportedObject = XPCAuthentication()
        newConnection.exportedInterface = NSXPCInterface(with: XPCAuthenticationProtocol.self)
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        return true
    }
}

let delegate = XPCAuthenticationDelegate()
let listener = NSXPCListener.service()
listener.delegate = delegate
listener.resume()
