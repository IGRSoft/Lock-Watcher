//
//  NSApplication+Dock.swift
//  IGR Software
//
//  Created by Vitalii P on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSApplication {
    
    /// Toggle visibility of icon on Dock
    /// 
    static func setDockIcon(hidden: Bool) {
        let policy: NSApplication.ActivationPolicy = hidden ? .accessory : .regular
        NSApp.setActivationPolicy(policy)
        let app = NSApplication.shared
        DispatchQueue.main.async {
            app.activate(ignoringOtherApps: true)
            app.windows.first?.orderFrontRegardless()
        }
    }
}
