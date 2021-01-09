//
//  TrigerManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import os

class TrigerManager {
    
    enum ListenerName: String {
        case onWakeUpListener, onWrongPassword, onBatteryPowerListener
    }
    
    typealias TrigerBlock = ((Bool) -> Void)
    
    private var settings: SettingsDto?
    
    private var listeners: [ListenerName : BaseListenerProtocol] = [.onWakeUpListener : WakeUpListener(),
                                                                    .onWrongPassword : WrongPasswordListener(),
                                                                    .onBatteryPowerListener : PowerListener()]
    
    public func start(settings: SettingsDto, _ trigerBlock: @escaping TrigerBlock = {trigered in}) {
        os_log(.debug, "Starting all trigers")
        
        let runListener:(BaseListenerProtocol, Bool) -> Void = {listener, isEnabled in
            if isEnabled == true {
                if listener.isRunning == false {
                    listener.start() { trigered in
                        trigerBlock(trigered)
                    }
                }
            }
            else if listener.isRunning == true {
                listener.stop()
            }
        }
        
        let enableOnWakeUpListener = settings.isUseSnapshotOnWakeUp == true
        let wakeUpListener = listeners[.onWakeUpListener]
        runListener(wakeUpListener!, enableOnWakeUpListener)
        
        let enableOnWrongPasswordListener = settings.isUseSnapshotOnWrongPassword == true
        let wrongPasswordListener = listeners[.onWrongPassword]
        runListener(wrongPasswordListener!, enableOnWrongPasswordListener)
        
        let enableOnBatteryPowerListener = settings.isUseSnapshotOnSwitchToBatteryPower == true
        let powerListener = listeners[.onBatteryPowerListener]
        runListener(powerListener!, enableOnBatteryPowerListener)
        
        self.settings = settings
    }
    
    public func stop() {
        os_log(.debug, "Stop all trigers")
        
        for listener in self.listeners.values {
            listener.stop()
        }
    }
}
