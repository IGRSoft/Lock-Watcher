//
//  AppCommons.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

struct Commons {
    /// General closure for empty response
    ///
    typealias EmptyClosure = () -> Void
    
    typealias BoolClosure = (Bool) -> Void
    
    typealias StringClosure = (String) -> Void
}

/// default states for SwiftUI View
///
enum StateMode: Int, CaseIterable {
    case idle
    case anonymous
    case authorised
    case progress
    case success
    case fault
    
    static var allCases: [StateMode] {
        [.idle, .anonymous, .authorised, .progress, .success, .fault]
    }
}

enum Secrets {
    #error("setup secrets")
    
    static let soul = ""
    static let keychainId = ""
    static let appKey = ""
    static let userDefaultsId = ""
    static let dropboxKey = ""
}
