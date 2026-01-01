//
//  FirstLaunchOptionsView.swift
//
//  Created on 04.07.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchOptionsView: View {
    @StateObject private var viewModel: FirstLaunchOptionsViewModel

    init(viewModel: FirstLaunchOptionsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            LaunchAtLoginView()
            UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: viewModel.isUseSnapshotOnWakeUp)
            UseSnapshotOnLoginView(isUseSnapshotOnLogin: viewModel.isUseSnapshotOnLogin)
            AddLocationToSnapshotView(addLocationToSnapshot: viewModel.addLocationToSnapshot)
            ICloudSyncView(isICloudSyncEnable: viewModel.isICloudSyncEnable)

            Divider()
        }
        .accessibilityIdentifier(AccessibilityID.FirstLaunch.optionsContainer)
    }
}

struct FirstLaunchOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchOptionsView(viewModel: FirstLaunchOptionsViewModel.preview)
    }
}
