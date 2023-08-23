//
//  LoginListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.09.2021.
//

import Foundation
import Cocoa

/// `LoginListener` checks Occlusion State changes to detect the status of the user.
/// It observes the occlusion state of the app, providing insights into the login status.
final class LoginListener: BaseListenerProtocol {
    
    //MARK: - Dependency injection
    
    /// Logger used to record information related to the Login Listener's behavior.
    private let logger: Log
    
    //MARK: - Variables
    
    /// Callback action to be triggered when the login is detected.
    var listenerAction: ListenerAction?
    
    /// A Boolean value indicating whether the listener is currently running.
    var isRunning: Bool = false
    
    /// A debounced function that gets triggered 500 milliseconds after `sessionDidBecomeActiveNotification` is called.
    private lazy var debouncedThief: () -> Void = {
        let debouncedFunction = DispatchQueue.main.debounce(interval: .milliseconds(500)) { [weak self] in
            let thief = ThiefDto()
            thief.triggerType = .logedIn
            
            DispatchQueue.main.async {
                self?.listenerAction?(.onLoginListener, thief)
            }
        }
        
        return debouncedFunction
    }()
    
    //MARK: - Initializer
    
    /// Initializes a new Login Listener with an optional logger.
    /// - Parameter logger: An instance of `Log`, defaults to `.loginListener`.
    init(logger: Log = Log(category: .loginListener)) {
        self.logger = logger
    }
    
    //MARK: - Public
    
    /// Starts the listener with the given action as a callback.
    /// - Parameter action: A closure that gets called when login is detected.
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        isRunning = true
        listenerAction = action
        
        // Start after 1s to ignore the first notification.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.sessionDidBecomeActiveNotification),
                                                   name: NSApplication.didChangeOcclusionStateNotification,
                                                   object: nil)
        }
    }
    
    /// Stops the listener, terminating any ongoing monitoring of login status.
    func stop() {
        logger.debug("stoped")
        isRunning = false
        listenerAction = nil
        
        NotificationCenter.default.removeObserver(self, name: NSApplication.didChangeOcclusionStateNotification, object: nil)
    }
    
    //MARK: - Private
    
    /// Private method to handle `didChangeOcclusionStateNotification`, which indicates a possible login event.
    /// This method triggers the `debouncedThief` action.
    @objc private func sessionDidBecomeActiveNotification() {
        logger.debug("didChangeOcclusionStateNotification")
        
        debouncedThief()
    }
}
