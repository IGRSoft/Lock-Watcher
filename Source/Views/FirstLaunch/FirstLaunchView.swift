//
//  FirstLaunchView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchView: View {
    
    @StateObject private var viewModel: FirstLaunchViewModel
    
    init(viewModel: FirstLaunchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack(alignment: .center, spacing: ViewConstants.spacing) {
            switch viewModel.state {
            case .idle:
                FirstLaunchOptionsView(viewModel: viewModel.firstLaunchOptionsViewModel)
                Button(action: viewModel.takeSnapshot, label: viewModel.takeSnapshotTitle)
                .alert(viewModel.openSettingsAlertTitle(), isPresented: $viewModel.showingAlert) {
                    Button(action: viewModel.openSettings, label: viewModel.openSettingsTitle)
                    Button(role: .cancel, action: { }, label: viewModel.cancelSettingsTitle)
                }
            case .progress:
                FirstLaunchProgressView(viewModel: FirstLaunchProgressViewModel(frameSize: viewModel.safeArea))
            case .success:
                FirstLaunchSuccessView(successCountDown: .constant(viewModel.successCountDown), frameSize: viewModel.safeArea)
            case .fault:
                if !viewModel.isNeedRestart {
                    FirstLaunchFaultViews(isHidden: $viewModel.isNeedRestart, frameSize: viewModel.safeArea)
                } else {
                    viewModel.restartView()
                }
            case .anonymous, .authorised:
                EmptyView()
            }
        }
        .padding(EdgeInsets(top: ViewConstants.doublePadding, leading: ViewConstants.doublePadding, bottom: ViewConstants.doublePadding, trailing: ViewConstants.doublePadding))
        .frame(width: viewModel.viewSettings.window.width, height: viewModel.viewSettings.window.height, alignment: .center)
        .onDisappear()
    }
}

struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView(viewModel: FirstLaunchViewModel.preview)
    }
}
