//
//  BaseListener.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

/// An enumeration representing the names of different listeners.
///
/// This enum identifies each listener that can be installed to monitor
/// specific system events, such as waking up from sleep or detecting
/// a USB connection.
public enum ListenerName: Int, Sendable {
    case onWakeUpListener           // Triggered when the system wakes up.
    case onWrongPassword            // Triggered when a wrong password is entered.
    case onBatteryPowerListener     // Triggered when the system switches to battery power.
    case onUSBConnectionListener    // Triggered when a USB device is connected.
    case onLoginListener            // Triggered when a user logs in.
}

/// A protocol defining the contract for listeners.
///
/// Conformers to this protocol are expected to monitor specific
/// events and notify via a callback when these events occur.
public protocol BaseListenerProtocol {
    /// A type alias for a closure that will be called when a listener is triggered.
    ///
    /// - Parameters:
    ///   - ListenerName: The name of the triggered listener.
    ///   - ThiefDto: A data transfer object containing details about the event or the  state
    ///     when the listener was triggered. This object's definition is not provided in the code snippet.
    typealias ListenerAction = ((ListenerName, TriggerType) -> Void)
    
    /// A callback that will be called when the listener detects its corresponding trigger.
    ///
    /// This is an optional property. If set, it will be executed when the
    /// listener is triggered.
    var listenerAction: ListenerAction? { get set }
    
    /// A boolean indicating whether the listener is currently running.
    ///
    /// This can be used to check if the listener is actively monitoring events.
    var isRunning: Bool { get }
    
    /// Starts the listener with a provided callback.
    ///
    /// When the listener detects its corresponding event, the provided
    /// callback will be executed. The callback is always executed on
    /// the main thread.
    ///
    /// - Parameters:
    ///   - action: The callback to be executed when the listener is triggered.
    func start(_ action: @escaping ListenerAction)
    
    /// Stops the listener from monitoring its corresponding event.
    ///
    /// After calling this method, the listener will no longer detect its
    /// trigger until `start` is called again.
    func stop()
}
