//
//  WrongPasswordListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import os

class WrongPasswordListener: BaseListener, BaseListenerProtocol {
    var listenerAction: ListenerAction?
    
    var isRunning: Bool = false
    
    func start(_ action: @escaping ListenerAction) {
        os_log(.debug, "WrongPasswordListener started")
        isRunning = true
    }
    
    func stop() {
        os_log(.debug, "WrongPasswordListener stoped")
        isRunning = false
    }
}
