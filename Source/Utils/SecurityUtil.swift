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

protocol SecurityUtilProtocol {
}

class SecurityUtil: SecurityUtilProtocol {
    
    class func save(password: String) {
        let keychain = Keychain(service: Secrets.keychainId)
        let hashString = hashString(for: password)
        
        #warning("need call not in main thread")
        keychain[Secrets.appKey] = hashString
    }
    
    class func isValid(password: String) -> Bool {
        let keychain = Keychain(service: Secrets.keychainId)
        let token = keychain[Secrets.appKey]
        let hashString = hashString(for: password)
        
        if token?.isEmpty != false || hashString.isEmpty != false {
            return false
        }
        
        return token == hashString
    }
    
    class func hasPassword() -> Bool {
        let keychain = Keychain(service: Secrets.keychainId)
        let token = keychain[Secrets.appKey]
        
        return token?.isEmpty == false
    }
    
    private class func hashString(for password: String) -> String {
        let dataToPack = Data((Secrets.soul + password).utf8)
        let hashed = SHA256.hash(data: dataToPack)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
