//
//  LoggerTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 29.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import XCTest
@testable import Lock_Watcher

class SomeClassThatUsesLog {
    let log: LogProtocol
    
    init(log: LogProtocol) {
        self.log = log
    }
    
    func debugMethodThatLogs() {
        log.debug("This is a debug message")
    }
    
    func infoMethodThatLogs() {
        log.info("This is a info message")
    }
    
    func errorMethodThatLogs() {
        log.error("This is a error message")
    }
}

class SomeClassThatUsesLogTests: XCTestCase {
    
    func testLogging() {
        let logMock = LogMock()
        let object = SomeClassThatUsesLog(log: logMock)
        
        object.debugMethodThatLogs()
        
        XCTAssertEqual(logMock.debugMessage, "This is a debug message")
        
        object.infoMethodThatLogs()
        
        XCTAssertEqual(logMock.infoMessage, "This is a info message")
        
        object.errorMethodThatLogs()
        
        XCTAssertEqual(logMock.errorMessage, "This is a error message")
    }
}

