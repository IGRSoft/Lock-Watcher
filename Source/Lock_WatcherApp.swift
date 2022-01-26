//
//  Lock_WatcherApp.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI
import UserNotifications

@main
struct Lock_WatcherApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
    
    class AppDelegate: NSObject, NSApplicationDelegate {
        var popover = NSPopover.init()
        var statusBarItem: NSStatusItem?
     
        private lazy var settingsView = SettingsView(watchBlock: { triger in
            self.updateStatusBarIcon(triger: triger != .empty)
        })
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            createPopover()
            createStatusBarIcon()
            hideDockIcon()
            
            process(localNotification: notification)
        }
        
        func createPopover() {
            popover.behavior = .transient
            popover.animates = false
            popover.contentViewController = NSViewController()
            popover.contentViewController?.view = NSHostingView(rootView: settingsView)
        }
        
        func createStatusBarIcon() {
            statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem?.button?.imageScaling = .scaleProportionallyDown
            statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
            statusBarItem?.length = NSStatusItem.squareLength
            
            updateStatusBarIcon(triger: false)
        }
        
        func updateStatusBarIcon(triger: Bool) {
            let icon = triger ? NSImage(named: "MenuIconAlert") : NSImage(named: "MenuIcon")
            statusBarItem?.button?.image = icon
        }
        
        func hideDockIcon() {
            if NSApp.activationPolicy() != .accessory {
                NSApp.setActivationPolicy(.accessory)
                DispatchQueue.main.async {
                    NSApplication.shared.activate(ignoringOtherApps: true)
                    NSApplication.shared.windows.first!.makeKeyAndOrderFront(self)
                }
            }
        }
        
        func process(localNotification: Notification) {
            if let response = localNotification.userInfo?[NSApplication.launchUserNotificationUserInfoKey] as? UNNotificationResponse {
                let identifier = response.notification.request.identifier;
                settingsView.showSnapshot(identifier: identifier)
            }
        }
        
        @objc func showPopover(_ sender: AnyObject?) {
            if let button = statusBarItem?.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                updateStatusBarIcon(triger: false)
            }
        }
        
        @objc func closePopover(_ sender: AnyObject?) {
            popover.performClose(sender)
        }
        
        @objc func togglePopover(_ sender: AnyObject?) {
            if popover.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        }
    }
}
