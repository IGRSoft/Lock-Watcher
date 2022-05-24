//
//  AppSettings.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import Combine

struct UISettings: Codable {
    var isSecurityInfoHidden = true
    var isSnapshotInfoHidden = false
    var isOptionsInfoHidden = false
    var isSyncInfoHidden = true
}

struct OptionsSettings: Codable {
    var isFirstLaunch = true
    var keepLastActionsCount = 10
    var isSaveSnapshotToDisk = false
    var addLocationToSnapshot = false
    var addIPAddressToSnapshot = false
    var addTraceRouteToSnapshot = false
    var traceRouteServer = ""
    var isProtected = false
}

struct TriggerSettings: Codable {
    var isUseSnapshotOnWakeUp = true
    var isUseSnapshotOnLogin = true
    var isUseSnapshotOnWrongPassword = false
    var isUseSnapshotOnSwitchToBatteryPower = false
    var isUseSnapshotOnUSBMount = false
}

struct SyncSettings: Codable {
    var isSaveSnapshotToDisk = false
    var isSendNotificationToMail = false
    var mailRecipient = ""
    var isICloudSyncEnable = true
    var isDropboxEnable = false
    var dropboxName = ""
    var isUseSnapshotLocalNotification = false
}

final class AppSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
#if NON_MAS_CONFIG
    static var isMASBuild = false
#else
    static var isMASBuild = true
#endif
    
    static var isDebug = false
    
    static var firstLaunchSuccessConunt = 15
    
    @UserDefault("OptionsSettings", defaultValue: OptionsSettings()) var options: OptionsSettings {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("TriggerSettings", defaultValue: TriggerSettings()) var triggers: TriggerSettings {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("SyncSettings", defaultValue: SyncSettings()) var sync: SyncSettings {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("UISettings", defaultValue: UISettings()) var ui: UISettings {
        willSet {
            objectWillChange.send()
        }
    }
}
