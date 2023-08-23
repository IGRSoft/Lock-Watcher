//
//  AppCommonsTest.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 23.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

@testable import Lock_Watcher
import XCTest

class CommonTests: XCTestCase {

    // MARK: - Commons Tests
    
    func testEmptyClosure() {
        var wasCalled = false
        let closure: Commons.EmptyClosure = {
            wasCalled = true
        }
        
        closure()
        
        XCTAssertTrue(wasCalled, "Expected EmptyClosure to be called.")
    }
    
    func testBoolClosure() {
        var capturedBool: Bool?
        let closure: Commons.BoolClosure = { value in
            capturedBool = value
        }
        
        closure(true)
        
        XCTAssertEqual(capturedBool, true, "Expected BoolClosure to capture true.")
    }
    
    func testStringClosure() {
        var capturedString: String?
        let closure: Commons.StringClosure = { value in
            capturedString = value
        }
        
        let testString = "Test"
        closure(testString)
        
        XCTAssertEqual(capturedString, testString, "Expected StringClosure to capture provided string.")
    }

    // MARK: - StateMode Tests
    
    func testStateModeAllCases() {
        XCTAssertEqual(StateMode.allCases.count, 6, "Expected 6 cases in StateMode.")
        XCTAssertTrue(StateMode.allCases.contains(.idle))
        XCTAssertTrue(StateMode.allCases.contains(.anonymous))
        XCTAssertTrue(StateMode.allCases.contains(.authorised))
        XCTAssertTrue(StateMode.allCases.contains(.progress))
        XCTAssertTrue(StateMode.allCases.contains(.success))
        XCTAssertTrue(StateMode.allCases.contains(.fault))
    }
}
