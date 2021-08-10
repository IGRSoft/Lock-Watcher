//
//  MailNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import os
import CoreLocation

class MailNotifier {
    private let kServiceName = "com.igrsoft.XPCMail"
    
    private var connection: NSXPCConnection?
    
    private var service: XPCMailProtocol {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCMailProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = {
            os_log(.error, "Service MailNotifier interupted")
        }
        
        connection.invalidationHandler = {
            os_log(.error, "Service MailNotifier invalidated")
        }
        
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            os_log(.error, "Received error: \(error.localizedDescription)")
        } as? XPCMailProtocol
        
        self.connection = connection
        
        return service!
    }
    
    func send(photo path: String, to mail: String, coordinate: CLLocationCoordinate2D) -> Bool {
        service.sendMail(mail, coordinates: coordinate, attachment: path)
        return true
    }
}
