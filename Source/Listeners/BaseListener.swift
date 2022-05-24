//
//  BaseListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

public enum ListenerName: Int {
    case onWakeUpListener, onWrongPassword, onBatteryPowerListener, onUSBConnectionListenet, onLoginListenet
}

public protocol BaseListenerProtocol {
    typealias ListenerAction = ((ListenerName, ThiefDto) -> Void)
    
    var listenerAction: ListenerAction? { get set }
    var isRunning: Bool { get }
    
    func start(_ action: @escaping ListenerAction)
    func stop()
}

class BaseListener {
}
