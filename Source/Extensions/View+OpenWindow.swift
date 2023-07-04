//
//  View+OpenWindow.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 26.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

extension View {
    
    /// Display current view inside window
    /// - Parameters:
    ///   - title: String title of window
    ///   - sender: any object that creating that window
    /// - Returns: NSWindow of created window
    ///
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let window = NSWindow(contentViewController: controller)
        window.styleMask = [.closable, .titled]
        window.contentViewController = controller
        window.title = title
        window.isReleasedWhenClosed = true
        window.makeKeyAndOrderFront(sender)
        
        return window
    }
}
