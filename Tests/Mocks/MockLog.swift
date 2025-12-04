//
//  MockLog.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 30.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import XCTest
@testable import Lock_Watcher

/// Mock logger for unit tests.
/// Uses `@unchecked Sendable` because test mocks don't need thread safety guarantees.
final class LogMock: LogProtocol, @unchecked Sendable {
    var debugMessage: String?
    var infoMessage: String?
    var errorMessage: String?
    
    func debug(_ message: String) {
        debugMessage = message
    }
    
    func info(_ message: String) {
        infoMessage = message
    }
    
    func error(_ message: String) {
        errorMessage = message
    }
}
