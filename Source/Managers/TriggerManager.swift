//
//  TriggerManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import os

class TriggerManager {
    
    typealias TriggerBlock = ((ThiefDto) -> Void)
    
    private var settings: AppSettings?
    
    var runListener: ((BaseListenerProtocol, Bool) -> ())?
    
    private lazy var listeners: [ListenerName : BaseListenerProtocol] = {
        var listeners: [ListenerName : BaseListenerProtocol] = [.onWakeUpListener : WakeUpListener(),
                                                                .onBatteryPowerListener : PowerListener(),
                                                                .onUSBConnectionListener : USBListener(),
                                                                .onLoginListener : LoginListener()]
        
        if AppSettings.isMASBuild == false {
            listeners[.onWrongPassword] = WrongPasswordListener()
        }
        
        return listeners
    }()
    
    public func start(settings: AppSettings?, _ trigerBlock: @escaping TriggerBlock = {trigered in}) {
        os_log(.debug, "Starting all triggers")
        
        let runListener:(BaseListenerProtocol, Bool) -> () = {listener, isEnabled in
            if isEnabled == true {
                if listener.isRunning == false {
                    listener.start() { [weak self] type, trigered in
                        trigerBlock(trigered)
                        
                        self?.restartListener(type: type)
                    }
                }
            }
            else if listener.isRunning == true {
                listener.stop()
            }
        }
        
        self.runListener = runListener
        
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
        if let usbListener = listeners[.onUSBConnectionListener] {
            runListener(usbListener, isUseSnapshotOnUSBMount)
        }
        
        let isUseSnapshotOnLogin = settings?.triggers.isUseSnapshotOnLogin == true
        if let loginListener = listeners[.onLoginListener] {
            runListener(loginListener, isUseSnapshotOnLogin)
        }
        
        self.settings = settings
    }
    
    private func restartListener(type: ListenerName) {
        if let l = self.listeners[type] {
            l.stop()
        }
        
        var listener: BaseListenerProtocol!
        switch type {
        case .onWakeUpListener:
            listener = WakeUpListener()
        case .onWrongPassword:
            listener = WrongPasswordListener()
        case .onBatteryPowerListener:
            listener = PowerListener()
        case .onUSBConnectionListener:
            listener = USBListener()
        case .onLoginListener:
            listener = LoginListener()
        }
        
        self.listeners[type] = listener
        self.runListener?(listener, true)
    }
    
    public func stop() {
        os_log(.debug, "Stop all triggers")
        
        for listener in self.listeners.values {
            listener.stop()
        }
    }
}
