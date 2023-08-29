//
//  LoggerProtocol.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 29.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

/// `LogProtocol` provides structure for logging
protocol LogProtocol {
    /// Logs a debug message.
    /// - Parameter message: The message to be logged.
    func debug(_ message: String)
    
    /// Logs an informational message.
    /// - Parameter message: The message to be logged.
    func info(_ message: String)
    
    /// Logs an error message.
    /// - Parameter message: The message to be logged.
    func error(_ message: String)
}
