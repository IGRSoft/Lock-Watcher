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
    
    private lazy var listeners: [ListenerName : BaseListenerProtocol] = {
        var listeners: [ListenerName : BaseListenerProtocol] = [.onWakeUpListener : WakeUpListener(),
                                                                .onBatteryPowerListener : PowerListener(),
                                                                .onUSBConnectionListenet : USBListener(),
                                                                .onLoginListenet : LoginListener()]
        
        if AppSettings.isMASBuild == false {
            listeners[.onWrongPassword] = WrongPasswordListener()
        }
        
        return listeners
    }()
    
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
        
        let isUseSnapshotOnWakeUp = settings?.triggers.isUseSnapshotOnWakeUp == true
        if let wakeUpListener = listeners[.onWakeUpListener] {
            runListener(wakeUpListener, isUseSnapshotOnWakeUp)
        }
        
        let isUseSnapshotOnWrongPassword = settings?.triggers.isUseSnapshotOnWrongPassword == true
        if let wrongPasswordListener = listeners[.onWrongPassword] {
            runListener(wrongPasswordListener, isUseSnapshotOnWrongPassword)
        }
        
        let isUseSnapshotOnSwitchToBatteryPower = settings?.triggers.isUseSnapshotOnSwitchToBatteryPower == true
        if let powerListener = listeners[.onBatteryPowerListener] {
            runListener(powerListener, isUseSnapshotOnSwitchToBatteryPower)
        }
        
        let isUseSnapshotOnUSBMount = settings?.triggers.isUseSnapshotOnUSBMount == true
        if let usbListener = listeners[.onUSBConnectionListenet] {
            runListener(usbListener, isUseSnapshotOnUSBMount)
        }
        
        let isUseSnapshotOnLogin = settings?.triggers.isUseSnapshotOnLogin == true
        if let loginListener = listeners[.onLoginListenet] {
            runListener(loginListener, isUseSnapshotOnLogin)
        }
        
        self.settings = settings
    }
    
    public func stop() {
        os_log(.debug, "Stop all trigers")
        
        for listener in self.listeners.values {
            listener.stop()
        }
    }
}
