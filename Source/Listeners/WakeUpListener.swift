//
//  WakeUpListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import Cocoa
import os

class WakeUpListener: BaseListener, BaseListenerProtocol {
    var listenerAction: ListenerAction?
    
    var isRunning: Bool = false
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "WakeUpListener started")
        isRunning = true
        listenerAction = action
        
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(receiveWakeNotification),
                                                          name: NSWorkspace.screensDidWakeNotification,
                                                          object: nil)
    }
    
    func stop() {
        os_log(.debug, "WakeUpListener stoped")
        isRunning = false
        listenerAction = nil
        
        NSWorkspace.shared.notificationCenter.removeObserver(self, name: NSWorkspace.screensDidWakeNotification, object: nil)
    }
    
    @objc func receiveWakeNotification() {
        let thief = ThiefDto()
        thief.trigerType = .onWakeUp
        
        DispatchQueue.main.async { [weak self] in
            self?.listenerAction?(.onWakeUpListener, thief)
        }
    }
}
