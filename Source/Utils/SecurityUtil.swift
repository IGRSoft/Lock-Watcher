//
//  SecurityUtil.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 02.02.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation
import KeychainAccess
import CryptoKit

class SecurityUtil {
    private static let soul = "fd2JqkXql2fs\nR."
    private static let keychainId = "com.igrsoft.Lock-Watcher-access-token"
    private static let appKey = "lockwatchertoken"
    
    class func save(password: String) {
        let keychain = Keychain(service: keychainId)
        let hashString = hashString(for: password)
        
        keychain[appKey] = hashString
    }
    
    class func isValid(password: String) -> Bool {
        let keychain = Keychain(service: keychainId)
        let token = keychain[appKey]
        let hashString = hashString(for: password)
        
        if token?.isEmpty != false || hashString.isEmpty != false {
            return false
        }
        
        return token == hashString
    }
    
    class func hasPassword() -> Bool {
        let keychain = Keychain(service: keychainId)
        let token = keychain[appKey]
        
        return token?.isEmpty == false
    }
    
    private class func hashString(for password: String) -> String {
        let dataToPack = Data((soul + password).utf8)
        let hashed = SHA256.hash(data: dataToPack)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
