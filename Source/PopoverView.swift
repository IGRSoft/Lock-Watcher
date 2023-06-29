//
//  PopoverView.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 28.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct PopoverView: View {
    private struct K {
        static let windowWidth: CGFloat = 340
        static let windowBorder = EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        static let blockWidth = windowWidth - (windowBorder.leading + windowBorder.trailing)
    }
    
    typealias SettingsTriggerWatchBlock = ((TriggerType) -> Void)
    
    @ObservedObject private(set) var thiefManager: ThiefManager
    
    @State var isInfoHidden = true
    
    init(thiefManager: ThiefManager) {
        self.thiefManager = thiefManager
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                LastThiefDetectionView(databaseManager: $thiefManager.databaseManager)
            }
            .frame(width: K.blockWidth)
            
            VStack(alignment: .leading) {
                InfoView(thiefManager: thiefManager, isInfoHidden: $isInfoHidden)
            }
            .frame(width: K.blockWidth)
        }
        .padding(K.windowBorder)
        .frame(width: K.windowWidth)
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        //ForEach(["en", "ru", "uk"], id: \.self) { id in
        PopoverView(thiefManager: ThiefManager(settings: AppSettings()) )
        //.environment(\.locale, .init(identifier: id))
        //}
    }
}
