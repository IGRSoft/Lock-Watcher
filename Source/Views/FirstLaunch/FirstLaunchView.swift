//
//  FirstLaunchView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view that presents the user with different states during the first launch of the application.
struct FirstLaunchView: View {
    
    /// An observable object that manages the state and behavior for this view.
    @StateObject private var viewModel: FirstLaunchViewModel
    
    /// Initializes a new `FirstLaunchView` with the given view model.
    /// - Parameter viewModel: The view model that provides data and behavior for this view.
    init(viewModel: FirstLaunchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
#if DEBUG
        // Prints changes for debug purposes.
        let _ = Self._printChanges()
#endif
        VStack(alignment: .center, spacing: ViewConstants.spacing) {
            switch viewModel.state {
            case .idle:
                // Presents options to the user on the first launch.
                FirstLaunchOptionsView(viewModel: viewModel.firstLaunchOptionsViewModel)
                Button(action: viewModel.takeSnapshot, label: viewModel.takeSnapshotTitle)
                    .alert(viewModel.openSettingsAlertTitle(), isPresented: $viewModel.showingAlert) {
                        Button(action: viewModel.openSettings, label: viewModel.openSettingsTitle)
                        Button(role: .cancel, action: { }, label: viewModel.cancelSettingsTitle)
                    }
            case .progress:
                // Shows the progress state using a progress view.
                FirstLaunchProgressView(viewModel: FirstLaunchProgressViewModel(frameSize: viewModel.safeArea))
            case .success:
                // Displays a success message with a countdown.
                FirstLaunchSuccessView(successCountDown: .constant(viewModel.successCountDown), frameSize: viewModel.safeArea)
            case .fault:
                // Displays an error message. If a restart is needed, it triggers the restart view.
                if !viewModel.isNeedRestart {
                    FirstLaunchFaultViews(isHidden: $viewModel.isNeedRestart, frameSize: viewModel.safeArea)
                } else {
                    viewModel.restartView()
                }
            case .anonymous, .authorised:
                // These states do not have associated views.
                EmptyView()
            }
        }
        // Provides padding and a frame for the content.
        .padding(EdgeInsets(top: ViewConstants.doublePadding, leading: ViewConstants.doublePadding, bottom: ViewConstants.doublePadding, trailing: ViewConstants.doublePadding))
        .frame(width: viewModel.viewSettings.window.width, height: viewModel.viewSettings.window.height, alignment: .center)
    }
}

/// A preview provider for SwiftUI's design canvas.
struct FirstLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchView(viewModel: FirstLaunchViewModel.preview)
    }
}
