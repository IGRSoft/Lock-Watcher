//
//  NetworkUtilTests.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 30.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import XCTest
@testable import Lock_Watcher

final class NetworkUtilTests: XCTestCase {
    var networkUtil: NetworkUtilProtocol!
    var mockLogger: LogMock!
    
    override func setUp() {
        super.setUp()
        mockLogger = LogMock()
        networkUtil = NetworkUtil(logger: mockLogger)
    }
    
    override func tearDown() {
        mockLogger = nil
        networkUtil = nil
        super.tearDown()
    }
    
    // Mock network calls for these tests to run offline
    func testGetIFAddresses() {
        // Assuming that you would mock the actual network call and response
        let ipAddress = networkUtil.getIFAddresses()
        
        XCTAssertFalse(ipAddress.isEmpty, "The IP Address should be not empty")
        XCTAssertNil(mockLogger.errorMessage, "No error log should be generated when fetching IP Address successfully.")
    }
    
    func testGetTraceRoute_success() {
        let host = "8.8.8.8"
        let expectedTraceRoute = "Your mocked or expected trace route result"
        
        let expectation = expectation(description: "Expecting trace route to complete")
        
        networkUtil.getTraceRoute(host: host) { traceRoute in
            XCTAssertTrue(traceRoute.contains(host), "Trace route result should contains \(expectedTraceRoute)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetTraceRoute_failed() {
        let host = "8.8.8.8.8"
        let expectedTraceRoute = "Your mocked or expected trace route result"
        
        let expectation = expectation(description: "Expecting trace route to complete")
        
        networkUtil.getTraceRoute(host: host) { traceRoute in
            XCTAssertFalse(traceRoute.contains(host), "Trace route result should contains \(expectedTraceRoute)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
