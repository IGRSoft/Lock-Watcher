//
//  MainAppTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 23.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

@testable import Lock_Watcher
import XCTest
import UserNotifications

class AppDelegateModelTests: XCTestCase {
    
    var model: MockAppDelegateModel!
    
    override func setUp() {
        super.setUp()
        model = MockAppDelegateModel()
    }
    
    func testSetupWithNotification_valid() {
        // Given
        let notification = Notification(name: Notification.Name("TestNotification"))
        
        // Execute
        model.setup(with: notification)
        
        XCTAssertTrue(model.invokedSetup)
        XCTAssertTrue(model.invokedSetupParameters?.localNotification == notification)
    }
    
    func testCheckDropboxAuthWithURLs_valid() {
        // Given
        let validDropboxURL = URL(string: "scheme://dropboxKey")!
        
        // Execute & Assert for valid Dropbox URL
        let validDropboxURLs = [validDropboxURL]
        model.stubbedCheckDropboxAuthResult = true
        XCTAssertTrue(model.checkDropboxAuth(urls: validDropboxURLs) == true)
        XCTAssertTrue(validDropboxURLs == model.invokedCheckDropboxAuthParameters?.urls, "Expected to recognise valid Dropbox URL.")
    }
    
    func testCheckDropboxAuthWithURLs_invalid() {
        // Given
        let validDropboxURL = URL(string: "scheme://dropboxKey")!
        let invalidDropboxURL = URL(string: "scheme://invalidKey")!
        
        // Execute & Assert for valid Dropbox URL
        let validDropboxURLs = [validDropboxURL]
        let invalidDropboxURLs = [invalidDropboxURL]
        model.stubbedCheckDropboxAuthResult = false
        XCTAssertTrue(model.checkDropboxAuth(urls: invalidDropboxURLs) == false)
        XCTAssertTrue(validDropboxURLs != model.invokedCheckDropboxAuthParameters?.urls, "Expected to recognise valid Dropbox URL.")
    }
}

