//
//  SettingsViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import Combine

/// ViewModel for handling the settings and configuration of the app.
class SettingsViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    
    /// Represents the constants related to the view settings.
    typealias DomainViewConstant = SettingsDomain
    
    /// Contains the view settings for the domain.
    var viewSettings: SettingsDomain = .init()
    
    //MARK: - Types
    
    /// A closure type to handle trigger events.
    typealias SettingsTriggerWatchBlock = Commons.TriggerClosure
    
    //MARK: - Dependency injection
    
    /// A manager responsible for handling thief related functionalities.
    private var thiefManager: ThiefManagerProtocol
    
    /// Represents the app's settings.
    private var settings: AppSettingsProtocol
    
    //MARK: - Variables
    
    /// Indicates if the information is hidden or shown.
    @Published var isInfoHidden = true
    
    /// Indicates if access is granted to some resources.
    @Published var isAccessGranted = true
    
    /// Notifies views to refresh whenever underlying data changes.
    internal let objectWillChange = PassthroughSubject<Void, Never>()
    
    // Following bindings allow the views to read and modify the underlying settings' values.
    
    //MARK: - Bindings for UI settings
    
    // Binding for expanding or collapsing security info section.
    var isSecurityInfoExpand: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.ui.isSecurityInfoExpand
        }, set: {
            self.settings.ui.isSecurityInfoExpand = $0
            self.objectWillChange.send()
        })
    }
    
    // Binding for toggling app protection.
    var isProtected: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.options.isProtected
        }, set: {
            self.settings.options.isProtected = $0
            self.objectWillChange.send()
        })
    }
    
    // Binding for expanding or collapsing snapshot info section.
    var isSnapshotInfoExpand: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.ui.isSnapshotInfoExpand
        }, set: {
            self.settings.ui.isSnapshotInfoExpand = $0
            self.objectWillChange.send()
        })
    }
    
    //MARK: - Bindings for Trigger settings
    
    // Each of these bindings represents a trigger for taking snapshots based on different events.
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
    
    //MARK: - Bindings for Options settings
    
    // Binding for expanding or collapsing options info section.
    var isOptionsInfoExpand: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.ui.isOptionsInfoExpand
        }, set: {
            self.settings.ui.isOptionsInfoExpand = $0
            self.objectWillChange.send()
        })
    }
    
    // Number of actions to keep in history.
    var keepLastActionsCount: Binding<Int> {
        Binding<Int>(get: {
            self.settings.options.keepLastActionsCount
        }, set: {
            self.settings.options.keepLastActionsCount = $0
            self.objectWillChange.send()
        })
    }
    
    // Bindings for adding additional information to snapshots.
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
    
    // Server for performing trace route.
    var traceRouteServer: Binding<String> {
        Binding<String>(get: {
            self.settings.options.traceRouteServer
        }, set: {
            self.settings.options.traceRouteServer = $0
            self.objectWillChange.send()
        })
    }
    
    //MARK: - Bindings for Sync settings
    
    // Binding for saving snapshots to disk.
    var isSaveSnapshotToDisk: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.sync.isSaveSnapshotToDisk
        }, set: {
            self.settings.sync.isSaveSnapshotToDisk = $0
            self.objectWillChange.send()
        })
    }
    
    // Binding for expanding or collapsing sync info section.
    var isSyncInfoExpand: Binding<Bool> {
        Binding<Bool>(get: {
            self.settings.ui.isSyncInfoExpand
        }, set: {
            self.settings.ui.isSyncInfoExpand = $0
            self.objectWillChange.send()
        })
    }
    
    // Binding for sending notifications to mail.
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
    
    // Bindings related to different sync options.
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
    
    /// Closure to be executed when access is granted.
    var accessGrantedBlock: Commons.EmptyClosure?
    
    //MARK: - initialiser
    
    /// Initializer for the SettingsViewModel.
    init(settings: AppSettingsProtocol, thiefManager: ThiefManagerProtocol) {
        self.settings = settings
        self.thiefManager = thiefManager
        
        watchDropboxUserNameUpdate()
    }
    
    /// Requests the thief manager to restart watchers based on updated settings.
    func restartWatching() {
        thiefManager.restartWatching()
    }
    
    /// Enables or disables the location manager in the thief manager.
    func setupLocationManager(enable: Bool) {
        thiefManager.setupLocationManager(enable: enable)
    }
    
    /// Observes any updates to the Dropbox user's name and updates the setting accordingly.
    private func watchDropboxUserNameUpdate() {
        thiefManager.watchDropboxUserNameUpdate { [weak self] name in
            self?.settings.sync.dropboxName = name
            self?.objectWillChange.send()
        }
    }
}

/// Extension to provide preview instance for the SettingsViewModel.
extension SettingsViewModel {
    static var preview: SettingsViewModel = SettingsViewModel(settings: AppSettingsPreview(), thiefManager: ThiefManagerPreview())
}
