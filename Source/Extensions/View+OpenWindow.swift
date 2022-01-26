//
//  View+OpenWindow.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

extension View {
    
    @discardableResult
    func openInWindow(title: String, sender: Any?) -> NSWindow {
        let controller = NSHostingController(rootView: self)
        let win = NSWindow(contentViewController: controller)
        win.styleMask = [.closable, .titled]
        win.contentViewController = controller
        win.title = title
        win.makeKeyAndOrderFront(sender)
        
        return win
    }
}
