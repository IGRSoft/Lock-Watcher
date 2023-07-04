//
//  BaseListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

/// list of installed listeners
///
public enum ListenerName: Int {
    case onWakeUpListener, onWrongPassword, onBatteryPowerListener, onUSBConnectionListener, onLoginListener
}

public protocol BaseListenerProtocol {
    typealias ListenerAction = ((ListenerName, ThiefDto) -> Void)
    
    /// callback on trigger
    ///
    var listenerAction: ListenerAction? { get set }
    
    /// running status
    ///
    var isRunning: Bool { get }
    
    /// start listen with trigger detection callback
    /// return callback async on main thread
    /// 
    func start(_ action: @escaping ListenerAction)
    
    /// stop listen triggers
    ///
    func stop()
}
