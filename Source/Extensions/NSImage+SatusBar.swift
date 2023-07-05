//
//  NSImage+SatusBar.swift
//  IGR Software
//
//  Created by Vitalii P on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    
    /// icon for status bar button for triggered status
    ///
    static func statusBarIcon(triggered: Bool = false) -> NSImage? {
        return triggered ? .init(named: "MenuIconAlert") : .init(named: "MenuIcon")
    }
}
