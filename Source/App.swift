//
//  Lock_WatcherApp.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import UserNotifications

typealias AppEmptyClosure = () -> Void

@main
struct Lock_WatcherApp: App {
    
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
        
        private lazy var thiefManager = ThiefManager(settings: settings) { [unowned self] dto in
            statusBarItem.button?.image = MainCoordinator.statusBarIcon(triggered: dto.triggerType != .setup)
        }
        
        private lazy var coordinator: (any BaseCoordinatorProtocol) = { [unowned self] in
            MainCoordinator(settings: settings, thiefManager: thiefManager, statusBarButton: statusBarItem.button!)
        }()
        
        /// base statusBar item
        ///
        private lazy var statusBarItem: NSStatusItem = {
            let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem.button?.imageScaling = .scaleProportionallyDown
            statusBarItem.button?.action = #selector(AppDelegate.togglePopover(_:))
            statusBarItem.button?.image = NSImage(named: "MenuIcon")
            statusBarItem.length = NSStatusItem.squareLength
            
            return statusBarItem
        }()
        
        /// Control FirstLaunchView visibility
        ///
        fileprivate lazy var settingsView = SettingsView(settings: settings, thiefManager: thiefManager)
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            applyTheme()
                        
            coordinator.displayFirstLaunchWindowIfNeed(isHidden: .constant(false)) {
                [weak self] in
                self?.coordinator.displayMainWindow()
            }
            
            process(localNotification: notification)
        }
        
        private func applyTheme() {
            hideDockIcon()
        }

        func applicationDidBecomeActive(_ notification: Notification) {
            DispatchQueue.main.debounce(interval: .milliseconds(100)) { [weak self] in
                self?.coordinator.displayMainWindow()
            }()
        }
        
        private func hideDockIcon() {
            if NSApp.activationPolicy() != .accessory {
                NSApp.setActivationPolicy(.accessory)
                DispatchQueue.main.async {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                    NSApplication.shared.windows.first!.makeKeyAndOrderFront(self)
                }
            }
        }
        
        private func process(localNotification: Notification) {
            if let response = localNotification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? UNNotificationResponse {
                let identifier = response.notification.request.identifier;
                settingsView.showSnapshot(identifier: identifier)
            }
        }
        
        @objc
        private func togglePopover(_ sender: NSStatusBarButton) {
            coordinator.toggleMainWindow()
        }
    }
}
