//
//  NSApplication+Settings.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 28.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit
import SwiftUI

extension NSApplication {
    
    /// Displays the application settings or preferences window.
    ///
    /// Depending on the macOS version, it either opens the 'settings' or 'preferences' window.
    /// For macOS versions 13.0 and newer, it will attempt to open the 'settings' window,
    /// while for older versions, it will attempt to open the 'preferences' window.
    static func displaySettingsWindow() {
        // If the macOS version is 13.0 or newer, trigger the 'showSettingsWindow' selector,
        // otherwise, trigger the 'showPreferencesWindow' selector.
        if #available(macOS 13.0, *) {
            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        }
        else {
            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        
        // Activate the application, bringing it to the foreground.
        NSApp.activate(ignoringOtherApps: true)
    }
}
