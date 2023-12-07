//
//  ICloudNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 10.08.2021.
//

import AppKit
import CoreLocation

/// A service responsible for handling and sending image notifications to iCloud.
///
/// The `iCloudNotifier` interacts with the iCloud and sends an image captured from the `ThiefDto`
/// data object to the user's iCloud Documents folder.
final class ICloudNotifier: NotifierProtocol {
    
    //MARK: - Dependency injection
    
    /// Logger instance responsible for capturing and logging events or errors.
    private var logger: LogProtocol
    
    //MARK: - Variables
    
    /// Name of the iCloud directory where images are saved.
    /// Default is "Documents".
    private var documentsFolderName = "Documents"
    
    //MARK: - Initializer
    
    /// Initializes a new instance of the `ICloudNotifier` with the provided logger or a default logger.
    ///
    /// - Parameter logger: An optional logger instance for capturing and logging events.
    init(logger: LogProtocol = Log(category: .iCloudNotifier)) {
        self.logger = logger
    }
    
    //MARK: - Public methods
    
    /// Registers the notifier with the provided application settings.
    ///
    /// - Parameter settings: The application settings to configure the iCloud notifier.
    func register(with settings: AppSettingsProtocol) {
        // This method is left blank for future settings integrations.
    }
    
    /// Sends an image notification based on the provided `ThiefDto` information.
    ///
    /// This function saves the image with optional text derived from `thiefDto.description()`
    /// to the iCloud's "Documents" folder.
    ///
    /// - Parameter thiefDto: The data object containing the details to be saved as an image.
    ///
    /// - Returns: A boolean value indicating whether the image was successfully sent.
    func send(_ thiefDto: ThiefDto) -> Bool {
        guard let localURL = thiefDto.filePath else {
            let msg = "wrong file path"
            logger.error(msg)
            assert(false, msg)
            
            return false
        }
        
        guard var iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent(documentsFolderName) else {
            let msg = "wrong iCloud url"
            logger.error(msg)
            assert(false, msg)
            
            return false
        }
        
        iCloudURL.appendPathComponent(localURL.lastPathComponent)
        
        var image = thiefDto.snapshot
        let info = thiefDto.description()
        if info.isEmpty == false {
            image = image?.imageWithText(text: info)
        }
        
        // Logging the iCloud save action.
        logger.debug("send: \(thiefDto)")
        
        do {
            let data = image?.jpegData
            try data?.write(to: iCloudURL)
        } catch {
            logger.error(error.localizedDescription)
            
            return false
        }
        
        return true
    }
}
