//
//  PopoverView.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 28.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct PopoverView: View {
    
    @StateObject private var viewModel: PopoverViewModel
    
    init(viewModel: PopoverViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                LastThiefDetectionView(viewModel: viewModel.lastThiefDetectionViewModel)
            }
            .frame(width: viewModel.blockWidth)
            
            VStack(alignment: .leading) {
                InfoView(thiefManager: viewModel.thiefManager, isInfoHidden: $viewModel.isInfoHidden)
            }
            .frame(width: viewModel.blockWidth)
        }
        .padding(viewModel.windowBorder)
        .frame(width: viewModel.windowWidth)
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        //ForEach(["en", "ru", "uk"], id: \.self) { id in
        PopoverView(viewModel: PopoverViewModel(thiefManager: ThiefManager(settings: AppSettings())))
        //.environment(\.locale, .init(identifier: id))
        //}
    }
}
