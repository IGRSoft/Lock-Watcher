//
//  USBListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.08.2021.
//

import Foundation
import Cocoa

/// Listen usb mount to send trigger
/// 
final class USBListener: BaseListenerProtocol {
    
    //MARK: - Dependency injection
    
    private let logger: Log
    
    //MARK: - Variables
    
    var listenerAction: ListenerAction?
    
    var isRunning: Bool = false
    
    //MARK: - initialiser
    
    init(logger: Log = Log(category: .usbListener)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    func start(_ action: @escaping ListenerAction) {
        logger.debug("started")
        isRunning = true
        listenerAction = action
        
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(receiveUSBNotification),
                                                          name: NSWorkspace.didMountNotification,
                                                          object: nil)
    }
    
    func stop() {
        logger.debug("stoped")
        isRunning = false
        listenerAction = nil
        
        NSWorkspace.shared.notificationCenter.removeObserver(self, name: NSWorkspace.didMountNotification, object: nil)
    }
    
    //MARK: - private
    
    @objc private func receiveUSBNotification() {
        let thief = ThiefDto()
        thief.triggerType = .usbConnected
        
        DispatchQueue.main.async { [weak self] in
            self?.listenerAction?(.onUSBConnectionListener, thief)
        }
    }
}
