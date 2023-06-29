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
    
    typealias SettingsModel = AppSettings
    
    private let logger: Log
    
    private var settings: SettingsModel
    
    private var thiefManager: ThiefManager
    
    /// popover with configuration to display from status bar icon
    ///
    private lazy var popover: NSPopover = {
        let popover = NSPopover.init()
        popover.behavior = .transient
        popover.animates = false
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: PopoverView(thiefManager: thiefManager))
        
        return popover
    }()
    
    private let statusBarButton: NSStatusBarButton
    
    init(logger: Log = Log(category: .coordinator), settings: SettingsModel, thiefManager: ThiefManager, statusBarButton: NSStatusBarButton) {
        self.logger = logger
        self.settings = settings
        self.thiefManager = thiefManager
        self.statusBarButton = statusBarButton
    }
    
    func displayMainWindow() {
        showSecurityAccessAlert { [unowned self] granted in
            if granted {
                statusBarButton.image = MainCoordinator.statusBarIcon()
                showPopover(for: statusBarButton)
            }
        }
    }
            
    func closeMainWindow() {
        closePopover(statusBarButton)
    }
        
    func toggleMainWindow() {
        if popover.isShown {
            closePopover(statusBarButton)
        } else {
            showPopover(for: statusBarButton)
        }
    }
    
    func displayFirstLaunchWindowIfNeed(isHidden: Binding<Bool>, closeClosure: @escaping AppEmptyClosure) {
        settings.options.isFirstLaunch = true
        if settings.options.isFirstLaunch {
            settings.options.isFirstLaunch = false
            FirstLaunchView(settings: settings, thiefManager: thiefManager, isHidden: isHidden, closeClosure: closeClosure)
                .openInWindow(title: NSLocalizedString("FirstLaunchSetup", comment: ""), sender: self)
        }
    }
        
    func displaySettingsWindow() {
        NSApplication.displaySettingsWindow()
    }
    
    private func showPopover(for button: NSStatusBarButton) {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    }
    
    private func closePopover(_ sender: NSStatusBarButton?) {
        popover.performClose(sender)
    }
    
    func togglePopover(_ sender: NSStatusBarButton) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(for: sender)
        }
    }
    
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
    
    static func statusBarIcon(triggered: Bool = false) -> NSImage? {
        return triggered ? .init(named: "MenuIconAlert") : .init(named: "MenuIcon")
    }
}

