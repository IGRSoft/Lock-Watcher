//
//  AppSettings.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import Combine

struct UISettings: Codable {
    var isSecurityInfoExpand: Bool = true
    var isSnapshotInfoExpand: Bool = false
    var isOptionsInfoExpand: Bool = false
    var isSyncInfoExpand: Bool = true
}

struct OptionsSettings: Codable {
    var isFirstLaunch: Bool = true
    var keepLastActionsCount: Int = 10
    var isSaveSnapshotToDisk: Bool = false
    var addLocationToSnapshot: Bool = false
    var addIPAddressToSnapshot: Bool = false
    var addTraceRouteToSnapshot: Bool = false
    var traceRouteServer: String = ""
    var isProtected: Bool = false
}

struct TriggerSettings: Codable {
    var isUseSnapshotOnWakeUp: Bool = true
    var isUseSnapshotOnLogin: Bool = true
    var isUseSnapshotOnWrongPassword: Bool = false
    var isUseSnapshotOnSwitchToBatteryPower: Bool = false
    var isUseSnapshotOnUSBMount: Bool = false
}

struct SyncSettings: Codable {
    var isSaveSnapshotToDisk: Bool = false
    var isSendNotificationToMail: Bool = false
    var mailRecipient: String = ""
    var isICloudSyncEnable: Bool = true
    var isDropboxEnable: Bool = false
    var dropboxName: String = ""
    var isUseSnapshotLocalNotification: Bool = false
}

protocol AppSettingsProtocol: ObservableObject {
    static var isMASBuild: Bool { get }
    
    static var isDebug: Bool { get }
    
    static var firstLaunchSuccessCount: Int { get }
    
    var options: OptionsSettings { get set }
    
    var triggers: TriggerSettings { get set }
    
    var sync: SyncSettings { get set }
    
    var ui: UISettings { get set }
}

final class AppSettings: AppSettingsProtocol {
    internal let objectWillChange = PassthroughSubject<Void, Never>()
    
#if NON_MAS_CONFIG
    static var isMASBuild: Bool = false
#else
    static var isMASBuild: Bool = true
#endif
    
    static var isDebug: Bool = true
    
    static var firstLaunchSuccessCount = 15
    
    @UserDefault("OptionsSettings", defaultValue: OptionsSettings()) var options: OptionsSettings {
        didSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("TriggerSettings", defaultValue: TriggerSettings()) var triggers: TriggerSettings {
        didSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("SyncSettings", defaultValue: SyncSettings()) var sync: SyncSettings {
        didSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("UISettings", defaultValue: UISettings()) var ui: UISettings {
        didSet {
            objectWillChange.send()
        }
    }
}
