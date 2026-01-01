//
//  AppDelegateModel.swift
//
//  Created on 27.08.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import UserNotifications

/// Protocol defining the app delegate model interface.
///
/// `@MainActor` isolation is required because the model manages UI components.
@MainActor
protocol AppDelegateModelProtocol {
    /// Represents the view model for application settings.
    var settingsView: SettingsView { get }

    /// Setup and processes local notifications.
    func setup(with localNotification: Notification)

    /// Checks and completes Dropbox authentication if URL contains the Dropbox key.
    func checkDropboxAuth(urls: [URL]) -> Bool
}

/// Application delegate model managing core app components.
///
/// `@MainActor` isolation ensures all UI-related state is accessed from the main thread.
final class AppDelegateModel: AppDelegateModelProtocol {
    /// Represents general settings for the application.
    private lazy var settings = AppSettings()

    /// Manages "Thief" operations based on provided settings.
    private lazy var thiefManager: ThiefManagerProtocol = ThiefManager(settings: settings) { [weak self] dto in
        // MainActor hop is required since ThiefClosure is @Sendable
        Task { @MainActor in
            self?.statusBarItem.button?.image = .statusBarIcon(triggered: dto.triggerType != .setup)
        }
    }
    
    /// Coordinates the manipulation and display of application windows.
    private lazy var coordinator: any BaseCoordinatorProtocol = { [unowned self] in
        guard let button = statusBarItem.button else {
            fatalError("Impossible to construct main coordinator, status bar button is missing.")
        }

        return MainCoordinator(settings: settings, thiefManager: thiefManager, statusBarButton: button, securityUtil: SecurityUtil())
    }()

    /// Represents the view model for application settings.
    private lazy var settingsViewModel: SettingsViewModel = .init(settings: settings, thiefManager: thiefManager)

    /// Represents the main view for application settings.
    private(set) lazy var settingsView = SettingsView(viewModel: settingsViewModel)

    /// Represents the status bar item used in the application.
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
    func setup(with localNotification: Notification) {
        applyTheme()

        coordinator.displayFirstLaunchWindowIfNeed { [weak self] in self?.coordinator.displayMainWindow() }

        if let response = localNotification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? UNNotificationResponse {
            thiefManager.showSnapshot(identifier: response.notification.request.identifier)
        }
    }

    /// Applies the application theme (hides the dock icon in this case).
    private func applyTheme() {
        NSApplication.setDockIcon(hidden: true)
    }

    /// Toggles the main application window visibility.
    @objc
    private func toggleMainWindow() {
        coordinator.toggleMainWindow()
    }
    
    /// Checks and completes Dropbox authentication if URL contains the Dropbox key.
    func checkDropboxAuth(urls: [URL]) -> Bool {
        if let url = urls.first(where: { $0.absoluteString.contains(Secrets.dropboxKey) }) {
            Task {
                _ = await thiefManager.completeDropboxAuthWith(url: url)
            }

            return true
        }

        return false
    }
}
