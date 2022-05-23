//
//  DeviceUtil.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 23.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation
import Darwin.sys.sysctl

class DeviceUtil {
    enum Devices {
        case laptop
        case nonLaptop
    }
    
    static func device() -> Devices {
        var size: size_t = 0
        let name = "hw.model"
        
        var res = sysctlbyname(name, nil, &size, nil, 0)
        
        if res != 0 {
            return .nonLaptop
        }
        
        var ret = [CChar].init(repeating: 0, count: size + 1)
        res = sysctlbyname(name, &ret, &size, nil, 0)
        
        let device = res == 0 ? String(cString: ret) : nil
        
        return device?.contains("MacBook") == true ? .laptop : .nonLaptop
    }
}
