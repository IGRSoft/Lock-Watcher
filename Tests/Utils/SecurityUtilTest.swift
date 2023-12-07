//
//  SecurityUtilTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 30.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import XCTest
@testable import Lock_Watcher

class SecurityUtilTests: XCTestCase {
    
    var securityUtil: SecurityUtilProtocol!
    
    override func setUp() {
        super.setUp()
        // Create a SecurityUtil instance with mock Secrets
        securityUtil = SecurityUtil(keychainId: "testKeychainId", soul: "testSoul", appKey: "testAppKey")
    }
    
    override func tearDown() {
        // Clear saved password, if any (this would require adding a clear method in your actual SecurityUtil class)
        // securityUtil.clear()
        securityUtil = nil
        super.tearDown()
    }
    
    // Success: Test Saving Password
    func testSavePassword_Success() {
        securityUtil.save(password: "testPassword")
        XCTAssertTrue(securityUtil.hasPassword(), "The password should be saved successfully.")
    }
    
    // Failure: Test Saving Empty Password
    func testSavePassword_Failure() {
        securityUtil.save(password: "")
        XCTAssertFalse(securityUtil.hasPassword(), "Empty password should not be saved.")
    }
    
    // Success: Test Valid Password
    func testIsValidPassword_Success() {
        securityUtil.save(password: "testPassword")
        XCTAssertTrue(securityUtil.isValid(password: "testPassword"), "The password should be valid.")
    }
    
    // Failure: Test Invalid Password
    func testIsValidPassword_Failure() {
        securityUtil.save(password: "testPassword")
        XCTAssertFalse(securityUtil.isValid(password: "wrongPassword"), "The password should be invalid.")
        
        securityUtil.save(password: "")
        XCTAssertFalse(securityUtil.isValid(password: "wrongPassword"), "The password should be invalid.")
        
        securityUtil.save(password: "testPassword")
        XCTAssertFalse(securityUtil.isValid(password: ""), "The password should be invalid.")
    }
}
