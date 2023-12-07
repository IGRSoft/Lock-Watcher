//
//  DispatchQueueDebounceTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 28.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

@testable import Lock_Watcher
import XCTest

class DispatchQueueDebounceTests: XCTestCase {
    
    func testDebounceExecutesActionAfterInterval() {
        // Create an expectation for a background download task to complete.
        let expectation = self.expectation(description: "Action should be executed after interval.")
        
        let queue = DispatchQueue(label: "test.queue")
        let debouncedAction = queue.debounce(interval: .milliseconds(100)) {
            expectation.fulfill()
        }
        
        debouncedAction()
        
        waitForExpectations(timeout: 0.110, handler: nil)
    }
    
    func testDebounceExecutesOnlyLastActionWithinInterval() {
        // Create an expectation for a background download task to complete.
        let expectation = self.expectation(description: "Only last action should be executed.")
        expectation.expectedFulfillmentCount = 1  // Only expect one call
        
        let queue = DispatchQueue(label: "test.queue")
        let debouncedAction = queue.debounce(interval: .milliseconds(100)) {
            expectation.fulfill()
        }
        
        debouncedAction()
        debouncedAction()
        debouncedAction()
        
        waitForExpectations(timeout: 0.101, handler: nil)
    }
    
    func testDebounceExecutesAllActionsIfCalledAfterInterval() {
        // Create an expectation for a background download task to complete.
        let expectation = self.expectation(description: "All actions should be executed.")
        expectation.expectedFulfillmentCount = 3  // Expect three calls
        
        let queue = DispatchQueue(label: "test.queue")
        let debouncedAction = queue.debounce(interval: .milliseconds(100)) {
            expectation.fulfill()
        }
        
        debouncedAction()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(150)) {
            debouncedAction()
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(300)) {
            debouncedAction()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
