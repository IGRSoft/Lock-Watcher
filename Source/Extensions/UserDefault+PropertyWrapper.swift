//
//  PropertyWrapper.swift
//  PropertyWrapper
//
//  Created by Vitalii Parovishnyk on 29.08.2021.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    private let userDefaultsId = "com.igrsoft.Lock-Watcher-defaults"
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? Data {
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    return object
                } catch {
                    print(error)
                    return defaultValue
                }
            } else if let object = UserDefaults.standard.object(forKey: key) as? T {
                return object
            } else {
                return defaultValue
            }
        }
        set {
            do {
                let encoded = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encoded, forKey: key)
            } catch {
                print(error)
            }
        }
    }
}
