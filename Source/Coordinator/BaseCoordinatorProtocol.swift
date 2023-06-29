//
//  BaseCoordinatorProtocol.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 28.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

protocol BaseCoordinatorProtocol {
    
    associatedtype SettingsModel: AppSettingsProtocol
    
    func displayMainWindow()
    
    func closeMainWindow()
    
    func toggleMainWindow()
    
    func displayFirstLaunchWindowIfNeed(isHidden: Binding<Bool>, closeClosure: @escaping AppEmptyClosure)
        
    func displaySettingsWindow()
}

class MainCoordinatorPreview: BaseCoordinatorProtocol {
    typealias SettingsModel = AppSettings
    
    func displayMainWindow() {}
    
    func closeMainWindow() {}
    
    func toggleMainWindow() {}
    
    func displayFirstLaunchWindowIfNeed(isHidden: Binding<Bool> = .constant(false), closeClosure: @escaping AppEmptyClosure = { } ) {}
        
    func displaySettingsWindow() {}
}
