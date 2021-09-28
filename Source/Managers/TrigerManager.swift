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
        case onWakeUpListener, onWrongPassword, onBatteryPowerListener, onUSBConnectionListenet, onLoginListenet
    }
    
    typealias TrigerBlock = ((ThiefDto) -> Void)
    
    private var settings: AppSettings?
    
#if NON_MAS_CONFIG
    private var listeners: [ListenerName : BaseListenerProtocol] = [.onWakeUpListener : WakeUpListener(),
                                                                    .onWrongPassword : WrongPasswordListener(),
                                                                    .onBatteryPowerListener : PowerListener(),
                                                                    .onUSBConnectionListenet : USBListener(),
                                                                    .onLoginListenet : LoginListener()]
    #else
    private var listeners: [ListenerName : BaseListenerProtocol] = [.onWakeUpListener : WakeUpListener(),
                                                                    .onBatteryPowerListener : PowerListener(),
                                                                    .onUSBConnectionListenet : USBListener(),
                                                                    .onLoginListenet : LoginListener()]
    #endif
    
    public func start(settings: AppSettings?, _ trigerBlock: @escaping TrigerBlock = {trigered in}) {
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
        
        let isUseSnapshotOnWakeUp = settings?.isUseSnapshotOnWakeUp == true
        let wakeUpListener = listeners[.onWakeUpListener]
        runListener(wakeUpListener!, isUseSnapshotOnWakeUp)
        
        #if NON_MAS_CONFIG
        let isUseSnapshotOnWrongPassword = settings?.isUseSnapshotOnWrongPassword == true
        let wrongPasswordListener = listeners[.onWrongPassword]
        runListener(wrongPasswordListener!, isUseSnapshotOnWrongPassword)
        #endif
        
        let isUseSnapshotOnSwitchToBatteryPower = settings?.isUseSnapshotOnSwitchToBatteryPower == true
        let powerListener = listeners[.onBatteryPowerListener]
        runListener(powerListener!, isUseSnapshotOnSwitchToBatteryPower)
        
        let isUseSnapshotOnUSBMount = settings?.isUseSnapshotOnUSBMount == true
        let usbListener = listeners[.onUSBConnectionListenet]
        runListener(usbListener!, isUseSnapshotOnUSBMount)
        
        let isUseSnapshotOnLogin = settings?.isUseSnapshotOnLogin == true
        let loginListener = listeners[.onLoginListenet]
        runListener(loginListener!, isUseSnapshotOnLogin)
        
        self.settings = settings
    }
    
    public func stop() {
        os_log(.debug, "Stop all trigers")
        
        for listener in self.listeners.values {
            listener.stop()
        }
    }
}
