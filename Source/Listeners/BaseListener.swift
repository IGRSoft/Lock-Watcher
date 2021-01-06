//
//  BaseListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

public protocol BaseListenerProtocol {
    typealias ListenerAction = ((Bool) -> Void)
    
    var listenerAction: ListenerAction? { get set }
    
    func start(_ action: @escaping ListenerAction)
    func stop()
}

class BaseListener {
    internal var settings: SettingsDto?
    
    init(settings: SettingsDto) {
        self.settings = settings
    }
}
