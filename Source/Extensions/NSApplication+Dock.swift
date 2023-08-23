//
//  NSApplication+Dock.swift
//  IGR Software
//
//  Created by Vitalii P on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSApplication {
    
    /// Toggles the visibility of the application's icon on the Dock.
    ///
    /// If the `hidden` parameter is `true`, the application's Dock icon is hidden, and the application behaves like an accessory application. 
    /// If `false`, the application's Dock icon is shown, and the application behaves like a regular application.
    ///
    /// - Parameter hidden: A Boolean value that determines whether to hide or show the Dock icon.
    static func setDockIcon(hidden: Bool) {
        // Determine the activation policy based on the hidden parameter.
        let policy: NSApplication.ActivationPolicy = hidden ? .accessory : .regular
        
        // Apply the activation policy.
        NSApp.setActivationPolicy(policy)
        
        // Get the shared application instance.
        let app = NSApplication.shared
        
        // Activate the application and bring its first window to the front.
        DispatchQueue.main.async {
            app.activate(ignoringOtherApps: true)
            app.windows.first?.orderFrontRegardless()
        }
    }
}
