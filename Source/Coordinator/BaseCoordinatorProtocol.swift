//
//  BaseCoordinatorProtocol.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 28.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

protocol BaseCoordinatorProtocol {
    
    
    /// Models to send objects to swift ui view
    ///
    associatedtype SettingsModel: AppSettingsProtocol
    
    associatedtype ThiefManagerModel: ThiefManagerProtocol
    
    /// Controll windows
    /// 
    func displayMainWindow()
    
    func closeMainWindow()
    
    func toggleMainWindow()
    
    /// Display First Launch Window on first start off app
    /// - Parameters:
    ///   - isHidden: Binding bool to control visibility with SwiftUI
    ///   - closeClosure: callback on close window
    ///
    func displayFirstLaunchWindowIfNeed(isHidden: Binding<Bool>, closeClosure: @escaping Commons.EmptyClosure)
        
    func displaySettingsWindow()
}

class MainCoordinatorPreview: BaseCoordinatorProtocol {
    typealias SettingsModel = AppSettings
    
    typealias ThiefManagerModel = ThiefManager
    
    func displayMainWindow() {}
    
    func closeMainWindow() {}
    
    func toggleMainWindow() {}
    
    func displayFirstLaunchWindowIfNeed(isHidden: Binding<Bool> = .constant(false), closeClosure: @escaping Commons.EmptyClosure = { } ) {}
        
    func displaySettingsWindow() {}
}
