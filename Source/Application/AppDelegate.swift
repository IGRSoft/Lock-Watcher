//
//  AppDelegate.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 27.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

/// Acts as the main delegate for the application, handling app lifecycle events and configurations.
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// Represents general settings for the application.
    let viewModel: AppDelegateModelProtocol
    
    init(viewModel: AppDelegateModelProtocol) {
        self.viewModel = viewModel
    }
    
    override convenience init() {
        self.init(viewModel: AppDelegateModel.init())
    }
    
    /// Called after the application finishes launching. Sets up theme and displays relevant windows.
    func applicationDidFinishLaunching(_ notification: Notification) {
        viewModel.setup(with: notification)
    }
    
    /// Handles URLs passed to the application upon opening.
    func application(_ application: NSApplication, open urls: [URL]) {
        guard viewModel.checkDropboxAuth(urls: urls) == false else { return }
    }
}
