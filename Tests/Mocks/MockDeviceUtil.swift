//
//  MockDeviceUtil.swift
//  Lock-WatcherTests
//
//  Created by Vitalii P on 30.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
@testable import Lock_Watcher

// MockDeviceUtil is a subclass of DeviceUtil used to override the behavior of `sysctlbyname`
class MockDeviceUtil: DeviceUtil {
    
    let mockDevice: String?
    
    init(mockDevice: String?) {
        self.mockDevice = mockDevice
    }
    
    override func device() -> Devices {
        return mockDevice?.contains("MacBook") == true ? .laptop : .nonLaptop
    }
}
