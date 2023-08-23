//
//  NotifierProtocol.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 05.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

/// Defines the behavior for a notifier.
/// 
/// A notifier is responsible for handling and dispatching notifications based on 
/// certain events or triggers in the application. This could be for logging, alerts, or other notifications.
protocol NotifierProtocol {
    
    /// Registers the notifier with the provided application settings.
    /// 
    /// This function initializes or sets up the notifier based on the configurations provided in the settings.
    /// 
    /// - Parameter settings: The application settings to configure the notifier.
    func register(with settings: AppSettingsProtocol)
    
    /// Sends a notification based on the provided `ThiefDto` information.
    /// 
    /// This function is used to dispatch a notification when a certain event or trigger is detected.
    /// 
    /// - Parameter thiefDto: The data object containing the details of the event or trigger.
    /// 
    /// - Returns: A boolean value indicating whether the notification was successfully sent.
    func send(_ thiefDto: ThiefDto) -> Bool
}
