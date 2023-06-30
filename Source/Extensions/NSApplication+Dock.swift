//
//  NSApplication+Dock.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSApplication {
    
    static func hideDockIcon() {
        if NSApp.activationPolicy() != .accessory {
            NSApp.setActivationPolicy(.accessory)
            DispatchQueue.main.async {
                NSApplication.shared.activate(ignoringOtherApps: true)
                NSApplication.shared.windows.first!.makeKeyAndOrderFront(self)
            }
        }
    }
}
