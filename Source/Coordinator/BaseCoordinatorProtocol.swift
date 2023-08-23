//
//  BaseCoordinatorProtocol.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 28.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// Defines the protocol for coordinating the display and control of windows within the app.
protocol BaseCoordinatorProtocol {
    
    /// Displays the main application window.
    func displayMainWindow()
    
    /// Closes the main application window.
    func closeMainWindow()
    
    /// Toggles the visibility of the main application window.
    func toggleMainWindow()
    
    /// Displays the first launch window if the app is being started for the first time.
    /// - Parameters:
    ///   - closeClosure: A callback that is invoked when the window is closed.
    func displayFirstLaunchWindowIfNeed(closeClosure: @escaping Commons.EmptyClosure)
    
    /// Displays the settings window.
    func displaySettingsWindow()
}

/// A preview implementation of the BaseCoordinatorProtocol used for testing or design purposes.
class MainCoordinatorPreview: BaseCoordinatorProtocol {
    
    /// Displays the main application window (no-op in preview).
    func displayMainWindow() {}
    
    /// Closes the main application window (no-op in preview).
    func closeMainWindow() {}
    
    /// Toggles the visibility of the main application window (no-op in preview).
    func toggleMainWindow() {}
    
    /// Displays the first launch window if needed (no-op in preview).
    /// - Parameter closeClosure: A closure that is called when the window is closed.
    func displayFirstLaunchWindowIfNeed(closeClosure: @escaping Commons.EmptyClosure = { } ) {}
    
    /// Displays the settings window (no-op in preview).
    func displaySettingsWindow() {}
}
