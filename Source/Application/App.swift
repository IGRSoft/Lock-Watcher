//
//  Lock_WatcherApp.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// Represents the main entry point of the application.
@main
struct MainApp: App {
    
    /// The application delegate to handle system-level events.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// Defines the main scene for the application.
    var body: some Scene {
        Settings {
            appDelegate.viewModel.settingsView
        }
    }
}
