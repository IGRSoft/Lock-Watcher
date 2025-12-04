//
//  LoginListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.09.2021.
//

import Cocoa
import Combine

/// `LoginListener` monitors macOS occlusion state changes to detect user login status.
/// It leverages a lock detector to identify transitions between locked and active states.
final class LoginListener: BaseListenerProtocol, @unchecked Sendable {
    // MARK: - Dependency Injection
    
    /// Logger for recording events and behavior of the login listener.
    private let logger: LogProtocol
    
    /// Lock detector for monitoring macOS lock state changes.
    private let lockDetector: MacOSLockDetectorProtocol
    
    // MARK: - Public Properties
    
    /// A closure to be executed when login is detected.
    var listenerAction: ListenerAction?
    
    /// Indicates whether the listener is currently running.
    private(set) var isRunning: Bool = false
    
    // MARK: - Private Properties
    
    /// Tracks whether the system was previously in a locked state.
    private var wasLocked = false
    
    /// Set of Combine cancellables to manage subscriptions.
    private var cancellables: Set<AnyCancellable> = .init()
    
    /// A debounced function triggered 500 milliseconds after detecting an active session.
    private lazy var debouncedThief: Commons.EmptyClosure = {
        let debouncedFunction = DispatchQueue.main.debounce(interval: .milliseconds(500), action: trigger)
        return debouncedFunction
    }()
    
    // MARK: - Initializer
    
    /// Creates an instance of `LoginListener`.
    /// - Parameters:
    ///   - logger: Logger instance for event logging. Defaults to `Log` with `.loginListener` category.
    ///   - lockDetector: A protocol instance for detecting lock state changes.
    init(logger: LogProtocol = Log(category: .loginListener), lockDetector: MacOSLockDetectorProtocol) {
        self.logger = logger
        self.lockDetector = lockDetector
    }
    
    // MARK: - Public Methods
    
    /// Starts monitoring the login state with a specified callback action.
    /// - Parameter action: A closure executed when login is detected.
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        isRunning = true
        listenerAction = action
        
        lockDetector.isLockedPublisher
            .sink(receiveValue: handleLockState)
            .store(in: &cancellables)
    }
    
    /// Stops monitoring login state and clears all active subscriptions.
    func stop() {
        logger.debug("stopped")
        isRunning = false
        listenerAction = nil
        cancellables.removeAll()
    }
    
    // MARK: - Private Methods
    
    /// Handles changes in the lock state provided by the `lockDetector`.
    /// - Parameter isLocked: A Boolean indicating whether the system is locked.
    private func handleLockState(_ isLocked: Bool) {
        if isLocked {
            wasLocked = true
        } else if wasLocked {
            debouncedThief()
        }
    }
    
    /// Debounced function to trigger the login listener action on the main queue.
    private func trigger() {
        DispatchQueue.main.async(execute: fireAction)
    }
    
    /// Executes the listener action with predefined parameters.
    @Sendable
    private func fireAction() {
        listenerAction?(.onLoginListener, .logedIn)
    }
}
