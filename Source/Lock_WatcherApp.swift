//
//  Lock_WatcherApp.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI

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
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            createPopover()
            createStatusBarIcon()
            hideDockIcon()
        }
        
        func createPopover() {
            popover.behavior = .transient
            popover.animates = false
            popover.contentViewController = NSViewController()
            popover.contentViewController?.view = NSHostingView(rootView: SettingsView())
        }
        
        func createStatusBarIcon() {
            statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            let icon = NSImage(named: "MenuIcon")
            icon?.isTemplate = true // best for dark mode
            statusBarItem?.button?.imageScaling = .scaleProportionallyDown
            statusBarItem?.button?.image = icon
            statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
            statusBarItem?.length = NSStatusItem.squareLength
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
        
        @objc func showPopover(_ sender: AnyObject?) {
            if let button = statusBarItem?.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
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
