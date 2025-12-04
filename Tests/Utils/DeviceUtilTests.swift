//
//  DeviceUtilTests.swift
//  Lock-WatcherTests
//
//  Created by Vitalii Parovishnyk on 30.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import XCTest
@testable import Lock_Watcher

final class DeviceUtilTests: XCTestCase {
    // Test for when the device is a laptop
    func testDeviceIsLaptop() {
        let deviceUtil = MockDeviceUtil(mockDevice: "MacBookPro")
        XCTAssertEqual(deviceUtil.device(), Devices.laptop, "Device should be identified as a laptop")
    }
    
    // Test for when the device is a non-laptop
    func testDeviceIsNonLaptop() {
        let deviceUtil = MockDeviceUtil(mockDevice: "iMac")
        XCTAssertEqual(deviceUtil.device(), Devices.nonLaptop, "Device should be identified as a non-laptop")
    }
    
    // Test for when the device model could not be determined
    func testDeviceIsUnknown() {
        let deviceUtil = MockDeviceUtil(mockDevice: nil)
        XCTAssertEqual(deviceUtil.device(), Devices.nonLaptop, "Device should be identified as a non-laptop by default")
    }
}
