//
//  NSImageSatusBarTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii P on 28.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

@testable import Lock_Watcher
import XCTest

class NSImageTests: XCTestCase {
    
    // Test that when the status is triggered, the alert icon is returned.
    func testStatusBarIconTriggered() {
        guard let icon = NSImage.statusBarIcon(triggered: true) else {
            XCTFail("Icon should not be nil.")
            return
        }
        
        XCTAssertEqual(icon.name(), "MenuIconAlert", "The icon name should be 'MenuIconAlert'.")
    }
    
    // Test that when the status is not triggered, the default menu icon is returned.
    func testStatusBarIconDefault() {
        guard let icon = NSImage.statusBarIcon() else {
            XCTFail("Icon should not be nil.")
            return
        }
        
        XCTAssertEqual(icon.name(), "MenuIcon", "The icon name should be 'MenuIcon'.")
    }
    
    // Test that when the status is explicitly set as not triggered, the default menu icon is returned.
    func testStatusBarIconNotTriggered() {
        guard let icon = NSImage.statusBarIcon(triggered: false) else {
            XCTFail("Icon should not be nil.")
            return
        }
        
        XCTAssertEqual(icon.name(), "MenuIcon", "The icon name should be 'MenuIcon'.")
    }
}
