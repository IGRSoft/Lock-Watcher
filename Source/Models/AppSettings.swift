//
//  AppSettings.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import Combine

final class AppSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
#if NON_MAS_CONFIG
    static var isMASBuild = false
#else
    static var isMASBuild = true
#endif
    
    @UserDefault("FirstLaunch", defaultValue: true) var isFirstLaunch: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("KeepLastActionsCount", defaultValue: 10) var keepLastActionsCount: Int {
        willSet {
            objectWillChange.send()
        }
    }

    @UserDefault("UseSnapshotOnWakeUp", defaultValue: false) var isUseSnapshotOnWakeUp: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("UseSnapshotOnLogin", defaultValue: false) var isUseSnapshotOnLogin: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("UseSnapshotOnWrongPassword", defaultValue: false) var isUseSnapshotOnWrongPassword: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("UseSnapshotOnSwitchToBatteryPower", defaultValue: false) var isUseSnapshotOnSwitchToBatteryPower: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("UseSnapshotOnUSBMount", defaultValue: false) var isUseSnapshotOnUSBMount: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("SaveSnapshotToDisk", defaultValue: false) var isSaveSnapshotToDisk: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("AddLocationToSnapshot", defaultValue: false) var addLocationToSnapshot: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("AddIPAddressToSnapshot", defaultValue: false) var addIPAddressToSnapshot: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("AddTraceRouteToSnapshot", defaultValue: false) var addTraceRouteToSnapshot: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("TraceRouteServer", defaultValue: "") var traceRouteServer: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("SendNotificationToMail", defaultValue: false) var isSendNotificationToMail: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("MailRecipient", defaultValue: "") var mailRecipient: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("iCloudSyncEnable", defaultValue: false) var isICloudSyncEnable: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("DropboxEnable", defaultValue: false) var isDropboxEnable: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("DropboxName", defaultValue: "") var dropboxName: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("UseSnapshotLocalNotification", defaultValue: false) var isUseSnapshotLocalNotification: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("IsProtected", defaultValue: false) var isProtected: Bool {
        willSet {
            objectWillChange.send()
        }
    }
}
