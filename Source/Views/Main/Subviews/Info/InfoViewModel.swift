//
//  InfoViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view model designed to manage the data and behaviors for the information section.
class InfoViewModel: ObservableObject {
    
    /// The thief manager responsible for handling thief-related actions and data.
    var thiefManager: any ThiefManagerProtocol
    
    /// A binding indicating whether the info section should be extended.
    @Binding var isInfoExtended: Bool
    
    /// Initializes a new `InfoViewModel`.
    ///
    /// - Parameters:
    ///   - thiefManager: The thief manager for this view model.
    ///   - isInfoExtended: A binding to control whether the info is extended.
    init(thiefManager: any ThiefManagerProtocol, isInfoExtended: Binding<Bool>) {
        self.thiefManager = thiefManager
        self._isInfoExtended = isInfoExtended
    }
    
    /// Provides the title for the debug section.
    @ViewBuilder
    func debugTitle() -> Text {
        Text("Debug")
    }
    
    /// Invokes the thief manager's detected trigger.
    func debugTrigger() {
        thiefManager.detectedTrigger { _ in }
    }
    
    /// Provides the title for the open settings button.
    @ViewBuilder
    func openSettingsTitle() -> Text {
        Text("ButtonSettings")
    }
    
    /// Opens the application's settings window.
    func openSettings() {
        NSApplication.displaySettingsWindow()
    }
    
    /// Provides the title for the quit application button.
    @ViewBuilder
    func quitAppTitle() -> Text {
        Text("Quit")
    }
    
    /// Quits the application.
    func quitApp() {
        exit(0)
    }
    
    /// The text for a link in the view.
    let linkText: String = "© IGR Software 2008 - 2023"
    
    /// The URL corresponding to the link text.
    let linkUrl: URL = URL(string: "https://igrsoft.com")!
}
