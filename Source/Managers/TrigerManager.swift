//
//  TrigerManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

class TrigerManager {
    
    typealias TrigerBlock = ((Bool) -> Void)
    
    private var settings: SettingsDto?
    
    private var listeners: [BaseListenerProtocol] = []
    
    init(settings: SettingsDto) {
        self.settings = settings
        self.listeners = [PowerListener(settings: settings)]
    }
    
    public func start(_ trigerBlock: @escaping TrigerBlock = {trigered in}) {
        self.stop()
        
        for listener in self.listeners {
            listener.start() { trigered in 
                trigerBlock(trigered)
            }
        }
    }
    
    public func stop() {
        for listener in self.listeners {
            listener.stop()
        }
    }
}
