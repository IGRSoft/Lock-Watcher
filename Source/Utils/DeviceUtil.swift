//
//  DeviceUtil.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 23.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation
import Darwin.sys.sysctl

/// `DeviceUtil` is a utility class that helps identify the type of macOS device.
public class DeviceUtil {
    
    /// Enumeration of supported device types.
    enum Devices {
        /// Represents macOS laptop devices (like MacBook, MacBook Pro, and MacBook Air).
        case laptop
        /// Represents non-laptop macOS devices (like iMac, Mac Mini, etc.).
        case nonLaptop
    }
    
    /// Fetches the device type based on the hardware model.
    ///
    /// - Returns: A `Devices` enumeration value representing the type of the device.
    static func device() -> Devices {
        var size: size_t = 0
        let name = "hw.model"
        
        // Querying for the size of the data type for the given name.
        var res = sysctlbyname(name, nil, &size, nil, 0)
        
        // If there's an error in fetching the size, return nonLaptop as a default.
        if res != 0 {
            return .nonLaptop
        }
        
        // Preparing the array to store the device name.
        var ret = [CChar].init(repeating: 0, count: size + 1)
        
        // Querying for the device name.
        res = sysctlbyname(name, &ret, &size, nil, 0)
        
        // If successfully retrieved the name, check if it contains "MacBook", indicating it's a laptop.
        let device = res == 0 ? String(cString: ret) : nil
        return device?.contains("MacBook") == true ? .laptop : .nonLaptop
    }
}
