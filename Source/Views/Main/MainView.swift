//
//  MainView.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 28.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        let _ = Self._printChanges()
        
        if viewModel.isAccessGranted {
            VStack(alignment: .leading) {
                LastThiefDetectionView(viewModel: viewModel.lastThiefDetectionViewModel)
                
                InfoView(viewModel: InfoViewModel(thiefManager: viewModel.thiefManager, isInfoExtended: $viewModel.isInfoExtended))
            }
            .padding(viewModel.viewSettings.border)
            .frame(width: viewModel.viewSettings.window.width)
        } else {
            Text("")
                .onAppear() {
                    viewModel.accessGrantedBlock?()
                }
        }
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        //ForEach(["en", "ru", "uk"], id: \.self) { id in
        MainView(viewModel: MainViewModel.preview)
        //.environment(\.locale, .init(identifier: id))
        //}
    }
}
