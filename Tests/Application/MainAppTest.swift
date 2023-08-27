//
//  MainAppTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii P on 23.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

/*@testable import Lock_Watcher
import XCTest
import UserNotifications

final class MainAppTest: XCTestCase {
    
    private var appDelegate: MainApp.AppDelegate!
    
    override func setUp() {
        super.setUp()
        appDelegate = MainApp.AppDelegate()
    }
    
    func testApplicationDidFinishLaunching() {
        // Setup mock
        let mockCoordinator = MockCoordinator()
        //appDelegate.coordinator = mockCoordinator
        
        // Execute
        appDelegate.applicationDidFinishLaunching(Notification(name: Notification.Name("TestNotification")))
        
        // Assert
        XCTAssertTrue(mockCoordinator.displayFirstLaunchWindowCalled, "Expected displayFirstLaunchWindowIfNeed() to be called.")
    }
    
    func testApplicationOpenURLs() {
        let mockThiefManager = MockThiefManager()
        //appDelegate.thiefManager = mockThiefManager
        let testURL = URL(string: "scheme://\(Secrets.dropboxKey)")!
        
        // Execute
        appDelegate.application(NSApplication.shared, open: [testURL])
        
        // Assert
        XCTAssertTrue(mockThiefManager.completeDropboxAuthCalled, "Expected completeDropboxAuthWith(url:) to be called.")
    }
    
    func testProcessLocalNotification() {
        let mockThiefManager = MockThiefManager()
        //appDelegate.thiefManager = mockThiefManager
        let testNotification = UNNotificationRequest(identifier: "testIdentifier", content: UNNotificationContent(), trigger: nil)
        let userInfo: [AnyHashable: Any] = [
            NSApplication.launchUserNotificationUserInfoKey: UNNotificationResponse.self
        ]
        let notification = Notification(name: Notification.Name("TestNotification"), object: nil, userInfo: userInfo)
        
        // Execute
        //appDelegate.process(localNotification: notification)
        
        // Assert
        XCTAssertTrue(mockThiefManager.showSnapshotCalled, "Expected showSnapshot(identifier:) to be called.")
    }
    
}
*/
