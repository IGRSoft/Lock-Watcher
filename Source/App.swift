//
//  Lock_WatcherApp.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import UserNotifications

@main
struct MainApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            appDelegate.settingsView
        }
    }
    
    class AppDelegate: NSObject, NSApplicationDelegate {
        
        /// General settings object
        ///
        private lazy var settings = AppSettings()
        
        /// General Thief manager based on settings
        ///
        private lazy var thiefManager: any ThiefManagerProtocol = ThiefManager(settings: settings) { [unowned self] dto in
            DispatchQueue.main.async { [weak self] in
                self?.statusBarItem.button?.image = .statusBarIcon(triggered: dto.triggerType != .setup)
            }
        }
        
        /// General coordinator to manipulate windows
        ///
        private lazy var coordinator: any BaseCoordinatorProtocol = { [unowned self] in
            guard let button = statusBarItem.button else {
                fatalError("impossible construct main coordinator, missed status Bar button")
            }
            
            return MainCoordinator(settings: settings, thiefManager: thiefManager, statusBarButton: button)
        }()
        
        private lazy var settingsViewModel: SettingsViewModel = SettingsViewModel(settings: settings, thiefManager: thiefManager)
        
        private(set) lazy var settingsView = SettingsView(viewModel: settingsViewModel)
        
        /// base statusBar item
        ///
        private lazy var statusBarItem: NSStatusItem = {
            let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem.button?.imageScaling = .scaleProportionallyDown
            statusBarItem.button?.action = #selector(toggleMainWindow)
            statusBarItem.button?.image = .statusBarIcon()
            statusBarItem.length = NSStatusItem.squareLength
            
            return statusBarItem
        }()
        
        @objc
        private func toggleMainWindow() {
            coordinator.toggleMainWindow()
        }
        
        /// Control FirstLaunchView visibility
        ///
        func applicationDidFinishLaunching(_ notification: Notification) {
            applyTheme()
            
            coordinator.displayFirstLaunchWindowIfNeed { [weak self] in self?.coordinator.displayMainWindow() }
            
            process(localNotification: notification)
        }
        
        func application(_ application: NSApplication, open urls: [URL]) {
            guard checkDropboxAuth(urls: urls) == false else { return }
        }
        
        private func process(localNotification: Notification) {
            if let response = localNotification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? UNNotificationResponse {
                thiefManager.showSnapshot(identifier: response.notification.request.identifier)
            }
        }
        
        private func applyTheme() {
            NSApplication.setDockIcon(hidden: true)
        }
        
        private func checkDropboxAuth(urls: [URL]) -> Bool {
            if let url = urls.first(where: { $0.absoluteString.contains(Secrets.dropboxKey) }) {
                thiefManager.completeDropboxAuthWith(url: url)
                
                return true
            }
            
            return false
        }
    }
}
