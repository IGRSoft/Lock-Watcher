//
//  WakeUpListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import Cocoa

/// Listen screen wake up notification from NSWorkspace
///
class WakeUpListener: BaseListenerProtocol {
    
    //MARK: - Dependency injection
    
    private let logger: Log
    
    //MARK: - Variables
    
    var listenerAction: ListenerAction?
    
    var isRunning: Bool = false
    
    //MARK: - initialiser
    
    init(logger: Log = Log(category: .wakeUpListener)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        
        isRunning = true
        listenerAction = action
        
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(receiveWakeNotification),
                                                          name: NSWorkspace.screensDidWakeNotification,
                                                          object: nil)
    }
    
    func stop() {
        logger.debug("stoped")
        
        isRunning = false
        listenerAction = nil
        
        NSWorkspace.shared.notificationCenter.removeObserver(self, name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
    
    //MARK: - private
    
    @objc private func receiveWakeNotification() {
        let thief = ThiefDto()
        thief.triggerType = .onWakeUp
        
        DispatchQueue.main.async { [weak self] in
            self?.listenerAction?(.onWakeUpListener, thief)
        }
    }
}
