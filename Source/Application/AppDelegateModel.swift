//
//  AppDelegateModel.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 27.08.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import UserNotifications

protocol AppDelegateModelProtocol {
    
    /// Represents the view model for application settings.
    var settingsView: SettingsView { get }
    
    /// Setup and processes local notifications.
    func setup(with localNotification: Notification)
    
    /// Checks and completes Dropbox authentication if URL contains the Dropbox key.
    func checkDropboxAuth(urls: [URL]) -> Bool
}

final class AppDelegateModel: @preconcurrency AppDelegateModelProtocol, @unchecked Sendable {
    
    /// Represents general settings for the application.
    private lazy var settings = AppSettings()
    
    /// Manages "Thief" operations based on provided settings.
    private lazy var thiefManager: ThiefManagerProtocol = ThiefManager(settings: settings) { [unowned self] dto in
        DispatchQueue.main.async { [weak self] in
            self?.statusBarItem.button?.image = .statusBarIcon(triggered: dto.triggerType != .setup)
        }
    }
    
    /// Coordinates the manipulation and display of application windows.
    @MainActor
    private lazy var coordinator: any BaseCoordinatorProtocol = { [unowned self] in
        guard let button = statusBarItem.button else {
            fatalError("Impossible to construct main coordinator, status bar button is missing.")
        }
        
        return MainCoordinator(settings: settings, thiefManager: thiefManager, statusBarButton: button, securityUtil: SecurityUtil())
    }()
    
    /// Represents the view model for application settings.
    private lazy var settingsViewModel: SettingsViewModel = SettingsViewModel(settings: settings, thiefManager: thiefManager)
    
    /// Represents the main view for application settings.
    @MainActor
    private(set) lazy var settingsView = SettingsView(viewModel: settingsViewModel)
    
    /// Represents the status bar item used in the application.
    @MainActor
    private lazy var statusBarItem: NSStatusItem = {
        let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusBarItem.button?.imageScaling = .scaleProportionallyDown
        statusBarItem.button?.action = #selector(toggleMainWindow)
        statusBarItem.button?.target = self
        statusBarItem.button?.image = .statusBarIcon()
        statusBarItem.length = NSStatusItem.squareLength
        
        return statusBarItem
    }()
    
    /// Setup and processes local notifications.
    @MainActor
    func setup(with localNotification: Notification) {
        applyTheme()
        
        coordinator.displayFirstLaunchWindowIfNeed { [weak self] in self?.coordinator.displayMainWindow() }
        
        if let response = localNotification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? UNNotificationResponse {
            thiefManager.showSnapshot(identifier: response.notification.request.identifier)
        }
    }
    
    /// Applies the application theme (hides the dock icon in this case).
    @MainActor
    private func applyTheme() {
        NSApplication.setDockIcon(hidden: true)
    }
    
    /// Toggles the main application window visibility.
    @MainActor
    @objc
    private func toggleMainWindow() {
        coordinator.toggleMainWindow()
    }
    
    /// Checks and completes Dropbox authentication if URL contains the Dropbox key.
    func checkDropboxAuth(urls: [URL]) -> Bool {
        if let url = urls.first(where: { $0.absoluteString.contains(Secrets.dropboxKey) }) {
            thiefManager.completeDropboxAuthWith(url: url)
            
            return true
        }
        
        return false
    }
}
