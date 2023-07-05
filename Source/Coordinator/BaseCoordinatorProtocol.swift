//
//  BaseCoordinatorProtocol.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 28.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

protocol BaseCoordinatorProtocol {
    
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
    func displayFirstLaunchWindowIfNeed(closeClosure: @escaping Commons.EmptyClosure)
    
    func displaySettingsWindow()
}

class MainCoordinatorPreview: BaseCoordinatorProtocol {
    
    func displayMainWindow() {}
    
    func closeMainWindow() {}
    
    func toggleMainWindow() {}
    
    func displayFirstLaunchWindowIfNeed(closeClosure: @escaping Commons.EmptyClosure = { } ) {}
    
    func displaySettingsWindow() {}
}
