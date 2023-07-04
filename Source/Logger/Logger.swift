//
//  Logger.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation
import os

struct Log {
    
    enum Category: String {
        case application
        case network
        case url
        case coordinator
        case settings
        
        case fileSystem
        
        case powerListener
        case wakeUpListener
        case wrongPasswordListener
        case usbListener
        case loginListener
    }
    
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    private let logger: Logger!
    
    init(category: Category) {
        logger = Logger(subsystem: Log.subsystem, category: category.rawValue)
    }
    
    func debug(_ message: String) {
        logger.debug("\(message)")
    }
    
    func info(_ message: String) {
        logger.info("\(message)")
    }
    
    func error(_ message: String) {
        logger.error("\(message)")
    }
}
