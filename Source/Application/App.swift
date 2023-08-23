//
//  Lock_WatcherApp.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import UserNotifications

/// Represents the main entry point of the application.
@main
struct MainApp: App {
    
    /// The application delegate to handle system-level events.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    /// Defines the main scene for the application.
    var body: some Scene {
        Settings {
            appDelegate.settingsView
        }
    }
    
    /// Acts as the main delegate for the application, handling app lifecycle events and configurations.
    class AppDelegate: NSObject, NSApplicationDelegate {
        
        /// Represents general settings for the application.
        private lazy var settings = AppSettings()
        
        /// Manages "Thief" operations based on provided settings.
        private lazy var thiefManager: any ThiefManagerProtocol = ThiefManager(settings: settings) { [unowned self] dto in
            DispatchQueue.main.async { [weak self] in
                self?.statusBarItem.button?.image = .statusBarIcon(triggered: dto.triggerType != .setup)
            }
        }
        
        /// Coordinates the manipulation and display of application windows.
        private lazy var coordinator: any BaseCoordinatorProtocol = { [unowned self] in
            guard let button = statusBarItem.button else {
                fatalError("Impossible to construct main coordinator, status bar button is missing.")
            }
            
            return MainCoordinator(settings: settings, thiefManager: thiefManager, statusBarButton: button)
        }()
        
        /// Represents the view model for application settings.
        private lazy var settingsViewModel: SettingsViewModel = SettingsViewModel(settings: settings, thiefManager: thiefManager)
        
        /// Represents the main view for application settings.
        private(set) lazy var settingsView = SettingsView(viewModel: settingsViewModel)
        
        /// Represents the status bar item used in the application.
        private lazy var statusBarItem: NSStatusItem = {
            let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem.button?.imageScaling = .scaleProportionallyDown
            statusBarItem.button?.action = #selector(toggleMainWindow)
            statusBarItem.button?.image = .statusBarIcon()
            statusBarItem.length = NSStatusItem.squareLength
            
            return statusBarItem
        }()
        
        /// Toggles the main application window visibility.
        @objc
        private func toggleMainWindow() {
            coordinator.toggleMainWindow()
        }
        
        /// Called after the application finishes launching. Sets up theme and displays relevant windows.
        func applicationDidFinishLaunching(_ notification: Notification) {
            applyTheme()
            
            coordinator.displayFirstLaunchWindowIfNeed { [weak self] in self?.coordinator.displayMainWindow() }
            
            process(localNotification: notification)
        }
        
        /// Handles URLs passed to the application upon opening.
        func application(_ application: NSApplication, open urls: [URL]) {
            guard checkDropboxAuth(urls: urls) == false else { return }
        }
        
        /// Processes local notifications.
        private func process(localNotification: Notification) {
            if let response = localNotification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? UNNotificationResponse {
                thiefManager.showSnapshot(identifier: response.notification.request.identifier)
            }
        }
        
        /// Applies the application theme (hides the dock icon in this case).
        private func applyTheme() {
            NSApplication.setDockIcon(hidden: true)
        }
        
        /// Checks and completes Dropbox authentication if URL contains the Dropbox key.
        private func checkDropboxAuth(urls: [URL]) -> Bool {
            if let url = urls.first(where: { $0.absoluteString.contains(Secrets.dropboxKey) }) {
                thiefManager.completeDropboxAuthWith(url: url)
                
                return true
            }
            
            return false
        }
    }
}
