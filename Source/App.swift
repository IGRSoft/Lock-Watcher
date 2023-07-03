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
            SettingsView(viewModel: SettingsViewModel(settings: appDelegate.settings, thiefManager: appDelegate.thiefManager))
        }
    }
    
    class AppDelegate: NSObject, NSApplicationDelegate {
        
        /// General settings object
        ///
        fileprivate lazy var settings = AppSettings()
        
        /// General Thief manager based on settings
        ///
        fileprivate lazy var thiefManager = ThiefManager(settings: settings) { [unowned self] dto in
            statusBarItem.button?.image = .statusBarIcon(triggered: dto.triggerType != .setup)
        }
        
        /// General coordinator to manipulate windows
        ///
        private lazy var coordinator: any BaseCoordinatorProtocol = { [unowned self] in
            guard let button = statusBarItem.button else {
                fatalError("impossible construct main coordinator, missed status Bar button")
            }
            
            return MainCoordinator(settings: settings, thiefManager: thiefManager, statusBarButton: button)
        }()
        
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
            
            coordinator.displayFirstLaunchWindowIfNeed(isHidden: .constant(false)) { [weak self] in self?.coordinator.displayMainWindow() }
            
            process(localNotification: notification)
        }
        
        private func process(localNotification: Notification) {
            if let response = localNotification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? UNNotificationResponse {
                thiefManager.showSnapshot(identifier: response.notification.request.identifier)
            }
        }
        
        private func applyTheme() {
            NSApplication.setDockIcon(hidden: true)
        }
    }
}
