//
//  MainCoordinator.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI
import LocalAuthentication

/// `MainCoordinator` manages and coordinates the main window of the application, especially its display and authentication.
final class MainCoordinator: BaseCoordinatorProtocol {
    
    //MARK: - Dependency Injection
    
    /// Configuration settings for the application.
    private var settings: any AppSettingsProtocol
    
    /// Likely manages data or tasks related to unauthorized access.
    private var thiefManager: any ThiefManagerProtocol
    
    //MARK: - Variables
    
    /// ViewModel for the main view.
    private lazy var mainViewModel = MainViewModel(thiefManager: thiefManager)
    
    /// Indicates if the application is currently unlocked.
    private var isUnlocked = false
    
    /// Logger instance for this module.
    private let logger: Log
    
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
    init(logger: Log = Log(category: .coordinator), settings: any AppSettingsProtocol, thiefManager: any ThiefManagerProtocol, statusBarButton: NSStatusBarButton) {
        self.logger = logger
        self.settings = settings
        self.thiefManager = thiefManager
        self.statusBarButton = statusBarButton
    }
    
    //MARK: - Public Functions
    
    /// Displays the main window after showing a security access alert.
    func displayMainWindow() {
        showSecurityAccessAlert { [unowned self] granted in
            if granted {
                statusBarButton.image = .statusBarIcon()
                showPopover(for: statusBarButton)
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
    
    /// Displays an alert to ask for a password to grant access to the application.
    ///
    /// - Parameter completion: A closure that receives a boolean indicating if the user is authenticated.
    private func showSecurityAccessAlert(completion: Commons.BoolClosure) {
        var isValid = true
        if settings.options.isProtected && SecurityUtil.hasPassword() {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("EnterPassword", comment: "")
            alert.addButton(withTitle: NSLocalizedString("ButtonOk", comment: ""))
            alert.addButton(withTitle: NSLocalizedString("ButtonCancel", comment: ""))
            alert.alertStyle = .warning
            
            let inputTextField = NSSecureTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
            alert.accessoryView = inputTextField
            if alert.runModal() == .OK {
                isValid = SecurityUtil.isValid(password: inputTextField.stringValue)
            }
        }
        
        completion(isValid)
    }
    
#warning("Add next release")
    
    /// Authenticates using biometrics or watch unlock.
    ///
    /// - Parameter action: Callback executed after authentication.
    private func authenticate(action: @escaping Commons.BoolClosure) {
        
        Timer.scheduledTimer(withTimeInterval: 900.0, repeats: false) { [weak self] _ in
            self?.isUnlocked = false
        }
        
        if isUnlocked == false {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, error: &error) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometricsOrWatch, localizedReason: NSLocalizedString("AuthInfo", comment: "")) { [weak self] success, authenticationError in
                    self?.isUnlocked = success
                    action(success == true)
                }
            } else {
                isUnlocked = true
                action(true)
            }
        } else {
            action(true)
        }
    }
}
