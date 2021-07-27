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
                        
            let contentView = SettingsView()

            popover.behavior = .transient
            popover.animates = false
            popover.contentViewController = NSViewController()
            popover.contentViewController?.view = NSHostingView(rootView: contentView)
            statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            statusBarItem?.button?.image = NSImage(named: "menuBarIcon")
            statusBarItem?.button?.action = #selector(AppDelegate.togglePopover(_:))
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
