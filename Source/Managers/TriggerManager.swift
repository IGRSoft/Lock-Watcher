//
//  TriggerManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

// Defines a protocol for trigger management.
protocol TriggerManagerProtocol {
    typealias TriggerBlock = ((ThiefDto) -> Void)
    
    /// Starts the trigger manager with given settings and an optional trigger block.
    func start(settings: (any AppSettingsProtocol)?, triggerBlock: @escaping TriggerBlock)
    
    /// Stops all running triggers.
    func stop()
}

final class TriggerManager: TriggerManagerProtocol {
    
    //MARK: - Dependency injection
    
    /// Holds the application settings.
    private var settings: (any AppSettingsProtocol)?
    
    /// Logger for module
    private var logger: Log
    
    /// A closure that takes a listener and a boolean flag to determine if the listener should run or not.
    var runListener: ((BaseListenerProtocol, Bool) -> ())?
    
    /// Holds a set of listeners that are configured based on certain conditions.
    private lazy var listeners: [ListenerName : BaseListenerProtocol] = {
        var listeners: [ListenerName : BaseListenerProtocol] = [.onWakeUpListener : WakeUpListener(),
                                                                .onBatteryPowerListener : PowerListener(),
                                                                .onUSBConnectionListener : USBListener(),
                                                                .onLoginListener : LoginListener()]
        
        // If the build isn't a Mac App Store build, exclude WrongPasswordListener
        if AppSettings.isMASBuild == false {
            listeners[.onWrongPassword] = WrongPasswordListener()
        }
        
        return listeners
    }()
    
    /// Initializer that configures the logger.
    init(logger: Log = .init(category: .triggerManager)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    /// Starts all listeners based on provided settings.
    public func start(settings: (any AppSettingsProtocol)?, triggerBlock: @escaping TriggerBlock = { triggered in }) {
        
        logger.debug("Starting all triggers")
        
        let runListener:(BaseListenerProtocol, Bool) -> () = { listener, isEnabled in
            if isEnabled == true {
                if listener.isRunning == false {
                    listener.start() { [weak self] type, triggered in
                        triggerBlock(triggered)
                        
                        self?.restartListener(type: type)
                    }
                }
            }
            else if listener.isRunning == true {
                listener.stop()
            }
        }
        
        self.runListener = runListener
        
        // Starts/stops individual listeners based on provided settings.
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
    
    /// Stops all active listeners.
    public func stop() {
        logger.debug("Stop all triggers")
        
        for listener in self.listeners.values {
            listener.stop()
        }
    }
    
    //MARK: - private
    
    /// Restarts a listener based on its type.
    private func restartListener(type: ListenerName) {
        if let l = self.listeners[type] {
            l.stop()
        }
        
        // Recreates the listener based on its type.
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
}
