//
//  FirstLaunchOptionsViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Combine
import SwiftUI

final class FirstLaunchOptionsViewModel: ObservableObject, @unchecked Sendable {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var settings: AppSettingsProtocol
    
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
