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

/// `SecurityUtilProtocol` provides an interface for security-related utilities.
protocol SecurityUtilProtocol {
    // Currently, this protocol doesn't specify any requirements.
    // This could be expanded based on the intended functionalities to be added.
}

/// `SecurityUtil` provides utilities for handling password-based functionalities, such as saving, validation, and checking existence in the keychain.
public class SecurityUtil: SecurityUtilProtocol {
    
    /// Save the hashed version of the password to the keychain.
    ///
    /// - Parameter password: The password to be hashed and saved.
    class func save(password: String) {
        let keychain = Keychain(service: Secrets.keychainId)
        let hashString = hashString(for: password)
        
        //need call not in main thread
        Task {
            keychain[Secrets.appKey] = hashString
        }
    }
    
    /// Validates if the given password matches the saved password hash in the keychain.
    ///
    /// - Parameter password: The password to validate.
    /// - Returns: A boolean indicating whether the password is valid or not.
    class func isValid(password: String) -> Bool {
        let keychain = Keychain(service: Secrets.keychainId)
        let token = keychain[Secrets.appKey]
        let hashString = hashString(for: password)
        
        if token?.isEmpty != false || hashString.isEmpty != false {
            return false
        }
        
        return token == hashString
    }
    
    /// Check if a password has already been saved in the keychain.
    ///
    /// - Returns: A boolean indicating whether a password exists in the keychain or not.
    class func hasPassword() -> Bool {
        let keychain = Keychain(service: Secrets.keychainId)
        let token = keychain[Secrets.appKey]
        
        return token?.isEmpty == false
    }
    
    /// Hashes the given password using SHA256.
    ///
    /// - Parameter password: The password to be hashed.
    /// - Returns: The SHA256 hashed string representation of the password.
    private class func hashString(for password: String) -> String {
        let dataToPack = Data((Secrets.soul + password).utf8)
        let hashed = SHA256.hash(data: dataToPack)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
