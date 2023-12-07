//
//  ListenerProtocolTest.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 28.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

@testable import Lock_Watcher
import XCTest

class ListenerTests: XCTestCase {

    var listener: MockListener!
    var dummyDTO: ThiefDto!

    override func setUpWithError() throws {
        listener = MockListener()
        dummyDTO = ThiefDto() // You would initialize this with valid data for testing.
    }

    override func tearDownWithError() throws {
        listener = nil
        dummyDTO = nil
    }
    
    func testListenerNameEnums() {
        XCTAssertEqual(ListenerName.onWakeUpListener.rawValue, 0)
        XCTAssertEqual(ListenerName.onWrongPassword.rawValue, 1)
        XCTAssertEqual(ListenerName.onBatteryPowerListener.rawValue, 2)
        XCTAssertEqual(ListenerName.onUSBConnectionListener.rawValue, 3)
        XCTAssertEqual(ListenerName.onLoginListener.rawValue, 4)
        
        let names: [ListenerName] = [.onWakeUpListener, .onWrongPassword, .onBatteryPowerListener, .onUSBConnectionListener, .onLoginListener]
        
        for name in names {
            switch name {
            case .onWakeUpListener:
                XCTAssertTrue(true)
            case .onWrongPassword:
                XCTAssertTrue(true)
            case .onBatteryPowerListener:
                XCTAssertTrue(true)
            case .onUSBConnectionListener:
                XCTAssertTrue(true)
            case .onLoginListener:
                XCTAssertTrue(true)
            }
        }
    }
    
    func testStartListener() {
        XCTAssertFalse(listener.isRunning)
        
        listener.start { _, _ in }
        
        XCTAssertTrue(listener.isRunning)
    }
    
    func testStopListener() {
        listener.start { _, _ in }
        XCTAssertTrue(listener.isRunning)
        
        listener.stop()
        
        XCTAssertFalse(listener.isRunning)
    }
    
    func testListenerAction() {
        var triggered = false
        listener.stubbedStartActionResult = (.onWakeUpListener, ThiefDto())
        listener.start { _, _ in
            triggered = true
        }
                
        XCTAssertTrue(triggered)
    }
    
    func testListenerReceivesCorrectEvent() {
        var receivedEvent: ListenerName?
        listener.stubbedStartActionResult = (.onWakeUpListener, ThiefDto())
        listener.start { name, _ in
            receivedEvent = name
        }
        
        let expectedEvent = ListenerName.onWakeUpListener
        
        XCTAssertEqual(receivedEvent, expectedEvent)
    }
}
