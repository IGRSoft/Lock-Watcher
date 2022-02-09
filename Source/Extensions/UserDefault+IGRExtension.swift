//
//  UserDefault+IGRExtension.swift
//  UserDefault+IGRExtension
//
//  Created by Vitalii Parovishnyk on 29.08.2021.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    private let userDefaultsId = "com.igrsoft.Lock-Watcher-defaults"
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults(suiteName: userDefaultsId)?.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults(suiteName: userDefaultsId)?.set(newValue, forKey: key)
        }
    }
}
