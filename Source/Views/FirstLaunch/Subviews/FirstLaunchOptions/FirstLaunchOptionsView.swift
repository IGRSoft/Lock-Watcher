//
//  FirstLaunchOptionsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchOptionsView: View {
    @StateObject private var viewModel: FirstLaunchOptionsViewModel
    
    init(viewModel: FirstLaunchOptionsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: ViewConstants.doublePadding) {
            LaunchAtLoginView()
            UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: viewModel.isUseSnapshotOnWakeUp)
            UseSnapshotOnLoginView(isUseSnapshotOnLogin: viewModel.isUseSnapshotOnLogin)
            AddLocationToSnapshotView(addLocationToSnapshot: viewModel.addLocationToSnapshot)
            ICloudSyncView(isICloudSyncEnable: viewModel.isICloudSyncEnable)
            
            Divider()
        }
    }
}

struct FirstLaunchOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchOptionsView(viewModel: FirstLaunchOptionsViewModel.preview)
    }
}
