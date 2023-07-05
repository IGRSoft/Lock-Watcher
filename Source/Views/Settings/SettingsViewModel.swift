//
//  SettingsViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Combine

class SettingsViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    
    typealias DomainViewConstant = SettingsDomain
    var viewSettings: SettingsDomain = .init()
    
    //MARK: - Types
    
    typealias SettingsTriggerWatchBlock = ((TriggerType) -> Void)
    
    //MARK: - Dependency injection
    
    private var thiefManager: any ThiefManagerProtocol
    
    private var settings: any AppSettingsProtocol
    
    //MARK: - Variables
    
    @Published var isInfoHidden = true
    @Published var isAccessGranted = true
    
    internal let objectWillChange = PassthroughSubject<Void, Never>()
    
    var isSecurityInfoExpand: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.ui.isSecurityInfoExpand
        }, set: {
            self.settings.ui.isSecurityInfoExpand = $0
            self.objectWillChange.send()
        })
    }
    
    var isProtected: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.options.isProtected
        }, set: {
            self.settings.options.isProtected = $0
            self.objectWillChange.send()
        })
    }
    
    var isSnapshotInfoExpand: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.ui.isSnapshotInfoExpand
        }, set: {
            self.settings.ui.isSnapshotInfoExpand = $0
            self.objectWillChange.send()
        })
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
    
    var isUseSnapshotOnWrongPassword: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.triggers.isUseSnapshotOnWrongPassword
        }, set: {
            self.settings.triggers.isUseSnapshotOnWrongPassword = $0
            self.objectWillChange.send()
        })
    }
    
    var isUseSnapshotOnSwitchToBatteryPower: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.triggers.isUseSnapshotOnSwitchToBatteryPower
        }, set: {
            self.settings.triggers.isUseSnapshotOnSwitchToBatteryPower = $0
            self.objectWillChange.send()
        })
    }
    
    var isUseSnapshotOnUSBMount: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.triggers.isUseSnapshotOnUSBMount
        }, set: {
            self.settings.triggers.isUseSnapshotOnUSBMount = $0
            self.objectWillChange.send()
        })
    }
    
    var isOptionsInfoExpand: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.ui.isOptionsInfoExpand
        }, set: {
            self.settings.ui.isOptionsInfoExpand = $0
            self.objectWillChange.send()
        })
    }
    
    var keepLastActionsCount: Binding<Int> {
        Binding<Int>(get: {
            self.settings.options.keepLastActionsCount
        }, set: {
            self.settings.options.keepLastActionsCount = $0
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
    
    var addIPAddressToSnapshot: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.options.addIPAddressToSnapshot
        }, set: {
            self.settings.options.addIPAddressToSnapshot = $0
            self.objectWillChange.send()
        })
    }
    
    var addTraceRouteToSnapshot: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.options.addTraceRouteToSnapshot
        }, set: {
            self.settings.options.addTraceRouteToSnapshot = $0
            self.objectWillChange.send()
        })
    }
    
    var traceRouteServer: Binding<String> {
        Binding<String>(get: {
            self.settings.options.traceRouteServer
        }, set: {
            self.settings.options.traceRouteServer = $0
            self.objectWillChange.send()
        })
    }
    
    var isSaveSnapshotToDisk: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.sync.isSaveSnapshotToDisk
        }, set: {
            self.settings.sync.isSaveSnapshotToDisk = $0
            self.objectWillChange.send()
        })
    }
    
    var isSyncInfoExpand: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.ui.isSyncInfoExpand
        }, set: {
            self.settings.ui.isSyncInfoExpand = $0
            self.objectWillChange.send()
        })
    }
    
    var isSendNotificationToMail: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.sync.isSendNotificationToMail
        }, set: {
            self.settings.sync.isSendNotificationToMail = $0
            self.objectWillChange.send()
        })
    }
    
    var mailRecipient: Binding<String> {
        Binding<String>(get: {
            self.settings.sync.mailRecipient
        }, set: {
            self.settings.sync.mailRecipient = $0
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
    
    var isDropboxEnable: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.sync.isDropboxEnable
        }, set: {
            self.settings.sync.isDropboxEnable = $0
            self.objectWillChange.send()
        })
    }
    
    var dropboxName: Binding<String> {
        Binding<String>(get: {
            self.settings.sync.dropboxName
        }, set: {
            self.settings.sync.dropboxName = $0
            self.objectWillChange.send()
        })
    }
    
    var isUseSnapshotLocalNotification: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.sync.isUseSnapshotLocalNotification
        }, set: {
            self.settings.sync.isUseSnapshotLocalNotification = $0
            self.objectWillChange.send()
        })
    }
    
    var accessGrantedBlock: Commons.EmptyClosure?
    
    //MARK: - initialiser
    
    init(settings: any AppSettingsProtocol, thiefManager: any ThiefManagerProtocol) {
        self.settings = settings
        self.thiefManager = thiefManager
    }
    
    func restartWatching() {
        thiefManager.restartWatching()
    }
    
    func setupLocationManager(enable: Bool) {
        thiefManager.setupLocationManager(enable: enable)
    }
}

extension SettingsViewModel {
    static var preview: SettingsViewModel = SettingsViewModel(settings: AppSettingsPreview(), thiefManager: ThiefManagerPreview())
}
