//
//  NetworkUtil.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation
import os

class NetworkUtil {
    class func getIFAddresses() -> String {
        var publicIP = ""
        do {
            try publicIP = String(contentsOf: URL(string: "https://api.ipify.org")!, encoding: String.Encoding.utf8)
            publicIP = publicIP.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        catch {
            os_log(.error, "Network Error: %@", "\(error)")
        }
        
        return publicIP
    }
}
