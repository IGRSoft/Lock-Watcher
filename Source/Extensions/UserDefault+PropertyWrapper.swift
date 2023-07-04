//
//  PropertyWrapper.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 29.08.2021.
//

import Foundation
import Combine

/// Property Wrapper for UserDefault
/// 
@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    private let userDefaults: UserDefaults
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
        
        self.userDefaults = UserDefaults.init(suiteName: Secrets.userDefaultsId)!
    }
    
    var wrappedValue: T {
        get {            
            if let data = userDefaults.object(forKey: key) as? Data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    return object
                } catch {
                    print(error)
                    return defaultValue
                }
            } else if let object = userDefaults.object(forKey: key) as? T {
                return object
            } else {
                return defaultValue
            }
        }
        set {
            do {
                let encoded = try JSONEncoder().encode(newValue)
                userDefaults.set(encoded, forKey: key)
            } catch {
                print(error)
            }
        }
    }
}
