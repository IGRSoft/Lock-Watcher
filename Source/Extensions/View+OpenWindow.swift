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
        let window = NSWindow(contentViewController: controller)
        window.styleMask = [.closable, .titled]
        window.contentViewController = controller
        window.title = title
        window.makeKeyAndOrderFront(sender)
        
        return window
    }
}
