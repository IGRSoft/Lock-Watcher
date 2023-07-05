//
//  LoginListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.09.2021.
//

import Foundation
import Cocoa

/// check Occlusion State changes to detect status of user
///
class LoginListener: BaseListenerProtocol {
    //MARK: - Dependency injection
    
    private let logger: Log
    
    //MARK: - Variables
    
    var listenerAction: ListenerAction?
    
    var isRunning: Bool = false
    
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
    
    //MARK: - initialiser
    
    init(logger: Log = Log(category: .loginListener)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        isRunning = true
        listenerAction = action
        
        // start in 1s to ignore first notification
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.sessionDidBecomeActiveNotification),
                                                   name: NSApplication.didChangeOcclusionStateNotification,
                                                   object: nil)
        }
    }
    
    func stop() {
        logger.debug("stoped")
        isRunning = false
        listenerAction = nil
        
        NotificationCenter.default.removeObserver(self, name: NSApplication.didChangeOcclusionStateNotification, object: nil)
    }
    
    //MARK: - private
    
    @objc private func sessionDidBecomeActiveNotification() {
        logger.debug("didChangeOcclusionStateNotification")
                
        debouncedThief()
    }
}
