//
//  FirstLaunchOptionsViewModel.swift
//
//  Created on 04.07.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import Observation
import SwiftUI

/// ViewModel for the first launch options configuration.
@Observable
@MainActor
final class FirstLaunchOptionsViewModel {
    /// The application settings.
    /// Ignored by observation as changes are tracked via bindings.
    var settings: AppSettingsProtocol

    init(settings: AppSettingsProtocol) {
        self.settings = settings
    }

    var isUseSnapshotOnWakeUp: Binding<Bool> {
        Binding<Bool>(
            get: { self.settings.triggers.isUseSnapshotOnWakeUp },
            set: { self.settings.triggers.isUseSnapshotOnWakeUp = $0 }
        )
    }

    var isUseSnapshotOnLogin: Binding<Bool> {
        Binding<Bool>(
            get: { self.settings.triggers.isUseSnapshotOnLogin },
            set: { self.settings.triggers.isUseSnapshotOnLogin = $0 }
        )
    }

    var addLocationToSnapshot: Binding<Bool> {
        Binding<Bool>(
            get: { self.settings.options.addLocationToSnapshot },
            set: { self.settings.options.addLocationToSnapshot = $0 }
        )
    }

    var isICloudSyncEnable: Binding<Bool> {
        Binding<Bool>(
            get: { self.settings.sync.isICloudSyncEnable },
            set: { self.settings.sync.isICloudSyncEnable = $0 }
        )
    }
}

extension FirstLaunchOptionsViewModel {
    static var preview: FirstLaunchOptionsViewModel {
        FirstLaunchOptionsViewModel(settings: AppSettingsPreview())
    }
}
