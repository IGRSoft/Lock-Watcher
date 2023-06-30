//
//  PopoverViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 30.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

class PopoverViewModel: ObservableObject {
    private enum K {
        static let windowWidth: CGFloat = 340
        static let windowBorder = EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        static let blockWidth = windowWidth - (windowBorder.leading + windowBorder.trailing)
    }
    
    typealias SettingsTriggerWatchBlock = ((TriggerType) -> Void)
    
    var windowWidth: CGFloat {
        K.windowWidth
    }
    
    var windowBorder: EdgeInsets {
        K.windowBorder
    }
    
    var blockWidth: CGFloat {
        K.blockWidth
    }
    
    @Published var thiefManager: any ThiefManagerProtocol
    
    @Published var isInfoHidden: Bool = true
    
    @Published var databaseManager: any DatabaseManagerProtocol
    
    @Published var lastThiefDetectionViewModel: LastThiefDetectionViewModel
    
    init(thiefManager: any ThiefManagerProtocol, isInfoHidden: Bool = true) {
        self.thiefManager = thiefManager
        self.databaseManager = thiefManager.databaseManager
        self.isInfoHidden = isInfoHidden
        self.lastThiefDetectionViewModel = LastThiefDetectionViewModel(databaseManager: thiefManager.databaseManager)
    }
}
