//
//  USBListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.08.2021.
//

import Foundation
import Cocoa

/// `USBListener` observes USB mount events on the system and triggers an action when a USB device is mounted.
final class USBListener: BaseListenerProtocol {
    
    //MARK: - Dependency injection
    
    /// Logger instance used for recording and debugging.
    private let logger: Log
    
    //MARK: - Variables
    
    /// Action to be triggered upon detecting a USB mount event.
    var listenerAction: ListenerAction?
    
    /// Indicates if the listener is currently monitoring USB mount events.
    var isRunning: Bool = false
    
    /// NotificationCenter to listen usb events
    private lazy var notificationCenter = NSWorkspace.shared.notificationCenter
    
    //MARK: - Initializer
    
    /// Initializes a `USBListener`.
    /// - Parameter logger: An instance of `Log` for logging purposes. Defaults to `.usbListener` category.
    init(logger: Log = Log(category: .usbListener)) {
        self.logger = logger
    }
    
    //MARK: - Public Methods
    
    /// Starts monitoring for USB mount events.
    /// - Parameter action: A closure that is called when a USB mount event is detected.
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        isRunning = true
        listenerAction = action
        
        // Register to observe USB mount notifications.
        notificationCenter.addObserver(self,
                                       selector: #selector(receiveUSBNotification),
                                       name: NSWorkspace.didMountNotification,
                                       object: nil)
    }
    
    /// Stops the listener from monitoring USB mount events.
    func stop() {
        logger.debug("stopped")
        isRunning = false
        listenerAction = nil
        
        // Remove the observer for USB mount notifications.
        notificationCenter.removeObserver(self, name: NSWorkspace.didMountNotification, object: nil)
    }
    
    //MARK: - Private Methods
    
    /// Handles the USB mount event notification.
    /// When called, prepares the data and triggers the action set by the `listenerAction`.
    @objc private func receiveUSBNotification() {
        let thief = ThiefDto()
        thief.triggerType = .usbConnected
        
        DispatchQueue.main.async { [weak self] in
            self?.listenerAction?(.onUSBConnectionListener, thief)
        }
    }
}
