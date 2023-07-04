//
//  InfoViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

class InfoViewModel: ObservableObject {
    var thiefManager: any ThiefManagerProtocol
        
    @Binding var isInfoExtended: Bool
    
    init(thiefManager: any ThiefManagerProtocol, isInfoExtended: Binding<Bool>) {
        self.thiefManager = thiefManager
        self._isInfoExtended = isInfoExtended
    }
    
    @ViewBuilder
    func debugTitle() -> Text {
        Text("Debug")
    }
    
    func debugTrigger() {
        thiefManager.detectedTrigger { _ in }
    }
    
    @ViewBuilder
    func openSettingsTitle() -> Text {
        Text("ButtonSettings")
    }
    
    func openSettings() {
        NSApplication.displaySettingsWindow()
    }
    
    @ViewBuilder
    func quitAppTitle() -> Text {
        Text("Quit")
    }
    
    func quitApp() {
        exit(0)
    }
    
    let linkText: String = "© IGR Software 2008 - 2023"
    
    let linkUrl: URL = URL(string: "https://igrsoft.com")!
}
