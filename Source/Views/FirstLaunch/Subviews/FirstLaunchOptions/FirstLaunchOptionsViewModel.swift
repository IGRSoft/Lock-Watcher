//
//  FirstLaunchOptionsViewModel.swift
//
//  Created on 04.07.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Combine
import SwiftUI

/// ViewModel for the first launch options configuration.
///
/// `@MainActor` isolation ensures UI state is always accessed from the main thread.
/// Uses `@preconcurrency` for ObservableObject to avoid Swift 6 concurrency warnings.
@MainActor
final class FirstLaunchOptionsViewModel: @preconcurrency ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    var settings: AppSettingsProtocol

    init(settings: AppSettingsProtocol) {
        self.settings = settings
    }

    var isUseSnapshotOnWakeUp: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.triggers.isUseSnapshotOnWakeUp
        }, set: {
            self.settings.triggers.isUseSnapshotOnWakeUp = $0
            self.objectWillChange.send()
        })
    }

    var isUseSnapshotOnLogin: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.triggers.isUseSnapshotOnLogin
        }, set: {
            self.settings.triggers.isUseSnapshotOnLogin = $0
            self.objectWillChange.send()
        })
    }

    var addLocationToSnapshot: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.options.addLocationToSnapshot
        }, set: {
            self.settings.options.addLocationToSnapshot = $0
            self.objectWillChange.send()
        })
    }

    var isICloudSyncEnable: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.sync.isICloudSyncEnable
        }, set: {
            self.settings.sync.isICloudSyncEnable = $0
            self.objectWillChange.send()
        })
    }
}

extension FirstLaunchOptionsViewModel {
    static var preview: FirstLaunchOptionsViewModel {
        FirstLaunchOptionsViewModel(settings: AppSettingsPreview())
    }
}
