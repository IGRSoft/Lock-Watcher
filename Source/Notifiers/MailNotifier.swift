//
//  MailNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import CoreLocation
import Foundation

/// A service responsible for handling and sending mail notifications.
///
/// The `MailNotifier` uses the XPCMail service to interact with the Mail app
/// and sends notifications or alerts based on the information provided in the `ThiefDto` data object.
/// The mails are sent using the default mail account configured in the Mail app.
final class MailNotifier: NotifierProtocol {
    // MARK: - Dependency injection
    
    /// Logger instance responsible for capturing and logging events or errors.
    private var logger: LogProtocol
    
    // MARK: - Variables
    
    /// The application settings used to configure the mail notifier.
    private var settings: AppSettingsProtocol!
    
    /// Constant identifier for the XPCMail service.
    private let kServiceName = "com.igrsoft.XPCMail"
    
    /// An XPC connection responsible for interprocess communication with the XPCMail service.
    private lazy var connection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: kServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCMailProtocol.self)
        connection.resume()
        
        // Handle interruptions and invalidations for the connection.
        connection.interruptionHandler = { [weak self] in
            self?.logger.error("XPCMail interrupted")
        }
        connection.invalidationHandler = { [weak self] in
            self?.logger.error("XPCMail invalidated")
        }
        
        return connection
    }()
    
    /// The remote service object that allows for communication with the XPCMail service.
    private lazy var service: XPCMailProtocol = {
        let service = connection.remoteObjectProxyWithErrorHandler { [weak self] error in
            self?.logger.error("Received error: \(error.localizedDescription)")
        } as! XPCMailProtocol
        
        return service
    }()
    
    // MARK: - Initializer
    
    /// Initializes a new instance of the `MailNotifier` with the provided logger or a default logger.
    ///
    /// - Parameter logger: An optional logger instance for capturing and logging events.
    init(logger: LogProtocol = Log(category: .mailNotifier)) {
        self.logger = logger
    }
    
    // MARK: - Public methods
    
    /// Registers the notifier with the provided application settings.
    ///
    /// - Parameter settings: The application settings to configure the mail notifier.
    func register(with settings: AppSettingsProtocol) {
        self.settings = settings
    }
    
    /// Sends a mail notification based on the provided `ThiefDto` information.
    ///
    /// This function communicates with the XPCMail service to dispatch the mail.
    ///
    /// - Parameter thiefDto: The data object containing the details to be included in the mail.
    ///
    /// - Returns: A boolean value indicating whether the mail was successfully sent.
    func send(_ thiefDto: ThiefDto) -> Bool {
        // Validation and error handling logic.
        guard let filePath = thiefDto.filePath?.path else {
            let msg = "wrong file path"
            logger.error(msg)
            assertionFailure(msg)
            
            return false
        }
        
        let mail = settings.sync.mailRecipient
        guard !mail.isEmpty else {
            let msg = "missed mail address"
            logger.error(msg)
            assertionFailure(msg)
            
            return false
        }
        
        // Logging the mail send action.
        logger.debug("send: \(thiefDto)")
        
        // Send the mail using the XPCMail service.
        service.sendMail(mail, coordinates: thiefDto.coordinate ?? kCLLocationCoordinate2DInvalid, attachment: filePath)
        
        return true
    }
}
