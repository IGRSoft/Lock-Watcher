//
//  Logger.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import os

/// `Log` provides structured logging capabilities across different categories of the application.
/// This structure aids in categorizing and filtering logs based on their types.
struct Log {
    
    /// `Category` enumerates various log types.
    /// Each case represents a specific category, making it easy to segregate and filter logs.
    enum Category: String {
        case application
        case network
        case url
        case coordinator
        case settings
        
        case fileSystem
        
        case powerListener
        case wakeUpListener
        case wrongPasswordListener
        case usbListener
        case loginListener
        
        case thiefManager
        case triggerManager
        
        case mailNotifier
        case iCloudNotifier
        case dropboxNotifier
        case notificationNotifier
        
        case networkUtil
    }
    
    /// The subsystem for the logs, typically the bundle identifier of the app.
    /// It provides a namespace for your logs, making them easier to identify and filter.
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// The logger instance from the OS logging system.
    private let logger: Logger
    
    /// Initializes a new `Log` instance for a given category.
    /// - Parameter category: The category for which the log will be generated.
    init(category: Category) {
        logger = Logger(subsystem: Log.subsystem, category: category.rawValue)
    }
    
    /// Logs a debug message.
    /// - Parameter message: The message to be logged.
    func debug(_ message: String) {
        logger.debug("\(message)")
    }
    
    /// Logs an informational message.
    /// - Parameter message: The message to be logged.
    func info(_ message: String) {
        logger.info("\(message)")
    }
    
    /// Logs an error message.
    /// - Parameter message: The message to be logged.
    func error(_ message: String) {
        logger.error("\(message)")
    }
}
