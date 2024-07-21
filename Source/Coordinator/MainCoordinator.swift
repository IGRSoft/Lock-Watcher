//
//  MainCoordinator.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI

/// `MainCoordinator` manages and coordinates the main window of the application, especially its display and authentication.
final class MainCoordinator: BaseCoordinatorProtocol {
    
    //MARK: - Dependency Injection
    
    /// Configuration settings for the application.
    private var settings: AppSettingsProtocol
    
    private let authManager: AuthentificationManager
    
    /// Likely manages data or tasks related to unauthorized access.
    private var thiefManager: ThiefManagerProtocol
    
    //MARK: - Variables
    
    /// ViewModel for the main view.
    private lazy var mainViewModel = MainViewModel(thiefManager: thiefManager)
    
    /// Logger instance for this module.
    private let logger: LogProtocol
    
    /// Popover displayed from the status bar icon.
    private lazy var mainPopover: NSPopover = {
        let popover = NSPopover.init()
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: MainView(viewModel: mainViewModel))
        
        return popover
    }()
    
    /// Status bar button that connects to the popover to display the main window.
    private let statusBarButton: NSStatusBarButton
    
    /// Window displayed during the application's first launch.
    private var firstLaunchWindow: NSWindow?
    
    //MARK: - Initialiser
    
    /// Initializes a new `MainCoordinator`.
    ///
    /// - Parameters:
    ///     - logger: Logger instance.
    ///     - settings: Application settings.
    ///     - thiefManager: Manager related to unauthorized access.
    ///     - statusBarButton: Status bar button to toggle the main window.
    init(logger: LogProtocol = Log(category: .coordinator), settings: AppSettingsProtocol, thiefManager: ThiefManagerProtocol, statusBarButton: NSStatusBarButton, securityUtil: SecurityUtilProtocol) {
        self.logger = logger
        self.settings = settings
        self.thiefManager = thiefManager
        self.statusBarButton = statusBarButton
        self.authManager = .init(logger: logger, securityUtil: securityUtil)
    }
    
    //MARK: - Public Functions
    
    /// Displays the main window after showing a security access alert.
    func displayMainWindow() {
        Task { @MainActor in
            if await authentificateIfNeeded() {
                statusBarButton.image = .statusBarIcon()
                showPopover(for: statusBarButton)
            }
        }
    }
    
    private func authentificateIfNeeded() async -> Bool {
        if !settings.options.isProtected {
            return true
        }
        else {
            do {
                return try await authManager.authenticate(with: settings.options.authSettings)
            }
            catch {
                await NSApp.presentError(error)
                return false
            }
        }
    }
    
    /// Closes the main window.
    func closeMainWindow() {
        closePopover(statusBarButton)
    }
    
    /// Toggles the visibility of the main window.
    func toggleMainWindow() {
        if mainPopover.isShown {
            closeMainWindow()
        } else {
            displayMainWindow()
        }
    }
    
    /// Displays a window on the first launch of the app.
    ///
    /// - Parameter closeClosure: Callback executed when the window is closed.
    func displayFirstLaunchWindowIfNeed(closeClosure: @escaping Commons.EmptyClosure) {
        if settings.options.isFirstLaunch {
            settings.options.isFirstLaunch = false
            firstLaunchWindow = FirstLaunchView(viewModel: FirstLaunchViewModel(settings: settings, thiefManager: thiefManager, closeClosure: { [weak self] in
                self?.firstLaunchWindow?.close()
                closeClosure()
            }))
            .openInWindow(title: NSLocalizedString("FirstLaunchSetup", comment: ""), sender: self)
        }
    }
    
    /// Displays the settings window.
    func displaySettingsWindow() {
        NSApplication.displaySettingsWindow()
    }
    
    //MARK: - Private Functions
    
    /// Displays the popover below the provided status bar button.
    ///
    /// - Parameter button: The status bar button.
    private func showPopover(for button: NSStatusBarButton) {
        mainPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    }
    
    /// Closes the popover.
    ///
    /// - Parameter sender: The UI component triggering the close action.
    private func closePopover(_ sender: NSStatusBarButton?) {
        mainPopover.performClose(sender)
    }
    
}
