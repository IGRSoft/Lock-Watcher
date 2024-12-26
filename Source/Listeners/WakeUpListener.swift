//
//  WakeUpListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import Cocoa

/// `WakeUpListener` observes the system for screen wake up events and triggers a specified action when such events are detected.
final class WakeUpListener: BaseListenerProtocol, @unchecked Sendable {
    
    //MARK: - Dependency injection
    
    /// Logger instance used for recording and debugging purposes.
    private let logger: LogProtocol
    
    //MARK: - Variables
    
    /// Action to be triggered upon detecting a screen wake up event.
    var listenerAction: ListenerAction?
    
    /// Indicates if the listener is currently monitoring screen wake up events.
    var isRunning: Bool = false
    
    /// NotificationCenter to monitoring screen wake up events.
    private lazy var notificationCenter = NSWorkspace.shared.notificationCenter
    
    //MARK: - Initializer
    
    /// Initializes a `WakeUpListener`.
    /// - Parameter logger: An instance of `Log` for logging purposes. Defaults to `.wakeUpListener` category.
    init(logger:LogProtocol  = Log(category: .wakeUpListener)) {
        self.logger = logger
    }
    
    //MARK: - Public Methods
    
    /// Starts monitoring for screen wake up events.
    /// - Parameter action: A closure that is called when a screen wake up event is detected.
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        isRunning = true
        listenerAction = action
        
        // Register to observe screen wake xup notifications.
        notificationCenter.addObserver(self,
                                       selector: #selector(receiveWakeNotification),
                                       name: NSWorkspace.screensDidWakeNotification,
                                       object: nil)
    }
    
    /// Stops the listener from monitoring screen wake up events.
    func stop() {
        logger.debug("stopped")
        
        isRunning = false
        listenerAction = nil
        
        // Remove the observer for screen wake up notifications.
        notificationCenter.removeObserver(self, name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
    
    //MARK: - Private Methods
    
    /// Handles the screen wake up event notification.
    /// When called, prepares the data and triggers the action set by the `listenerAction`.
    @objc private func receiveWakeNotification() {
        DispatchQueue.main.async(execute: fireAction)
    }
    
    @Sendable
    private func fireAction() {
        listenerAction?(.onWakeUpListener, .onWakeUp)
    }
}
