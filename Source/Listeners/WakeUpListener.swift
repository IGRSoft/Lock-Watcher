//
//  WakeUpListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import os

class WakeUpListener: BaseListener, BaseListenerProtocol {
    var listenerAction: ListenerAction?
    
    var isRunning: Bool = false
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "WakeUpListener started")
        isRunning = true
    }
    
    func stop() {
        os_log(.debug, "WakeUpListener stoped")
        isRunning = false
    }
}
