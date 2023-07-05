//
//  MainCoordinator.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI

class MainCoordinator: BaseCoordinatorProtocol {
    
    //MARK: - dependency injection
    private var settings: any AppSettingsProtocol
    private var thiefManager: any ThiefManagerProtocol
    
    // Logger for module
    private let logger: Log
    
    //MARK: - variables
    
    private lazy var mainViewModel = MainViewModel(thiefManager: thiefManager)
    
    /// popover with configuration to display from status bar icon
    ///
    private lazy var mainPopover: NSPopover = {
        let popover = NSPopover.init()
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: MainView(viewModel: mainViewModel))
        
        return popover
    }()
    
    /// Status Bar button to connect popover to it to display main window
    ///
    private let statusBarButton: NSStatusBarButton
    
    private var firstLaunchWindow: NSWindow?
    
    //MARK: - initialiser
    
    init(logger: Log = Log(category: .coordinator), settings: any AppSettingsProtocol, thiefManager: any ThiefManagerProtocol, statusBarButton: NSStatusBarButton) {
        self.logger = logger
        self.settings = settings
        self.thiefManager = thiefManager
        self.statusBarButton = statusBarButton
    }
    
    //MARK: - public funcs
    
    func displayMainWindow() {
        showSecurityAccessAlert { [unowned self] granted in
            if granted {
                statusBarButton.image = .statusBarIcon()
                showPopover(for: statusBarButton)
            }
        }
    }
    
    func closeMainWindow() {
        closePopover(statusBarButton)
    }
    
    func toggleMainWindow() {
        if mainPopover.isShown {
            closeMainWindow()
        } else {
            displayMainWindow()
        }
    }
    
    /// Display FirstLaunch Window If first launch of app
    /// - Parameter closeClosure: callback on close by timer
    ///
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
    
    func displaySettingsWindow() {
        NSApplication.displaySettingsWindow()
    }
    
    //MARK: - private funcs
    
    /// show popover down from StatusBar button
    ///
    private func showPopover(for button: NSStatusBarButton) {
        mainPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    }
    
    /// dismiss popover for StatusBar button
    ///
    private func closePopover(_ sender: NSStatusBarButton?) {
        mainPopover.performClose(sender)
    }
    
    /// alert to ask password to grant access to application
    ///
    private func showSecurityAccessAlert(completion: (Bool) -> Void) {
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
}
