//
//  MailNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import CoreLocation

/// Start XPCMail service to send message to Mail app
/// uses default account to send mail
/// 
final class MailNotifier: NotifierProtocol {
    
    //MARK: - Dependency injection
    
    private var logger: Log
    
    //MARK: - Variables
    
    private var settings: (any AppSettingsProtocol)!
    
    private let kServiceName = "com.igrsoft.XPCMail"
        
    private lazy var connection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCMailProtocol.self)
        connection.resume()
        
        connection.interruptionHandler = { [weak self] in
            self?.logger.error("XPCMail interrupted")
        }
        
        connection.invalidationHandler = { [weak self] in
            self?.logger.error("XPCMail invalidated")
        }
        
        return connection
    }()
    
    private lazy var service: XPCMailProtocol = {
        let service = connection.remoteObjectProxyWithErrorHandler { [weak self] error in
            self?.logger.error("Received error: \(error.localizedDescription)")
        } as! XPCMailProtocol
        
        return service
    }()
    
    //MARK: - initialiser
    
    init(logger: Log = .init(category: .mailNotifier)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    func register(with settings: any AppSettingsProtocol) {
        self.settings = settings
    }
    
    func send(_ thiefDto: ThiefDto) -> Bool {
        guard let filePath = thiefDto.filePath?.path else {
            let msg = "wrong file path"
            logger.error(msg)
            assert(false, msg)
            
            return false
        }
        
        let mail = settings.sync.mailRecipient
        guard !mail.isEmpty else {
            let msg = "missed mail address"
            logger.error(msg)
            assert(false, msg)
            
            return false
        }
        
        logger.debug("send: \(thiefDto)")
        
        service.sendMail(mail, coordinates: thiefDto.coordinate ?? kCLLocationCoordinate2DInvalid, attachment: filePath)
        
        return true
    }
}
