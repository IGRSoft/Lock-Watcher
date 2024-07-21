//
//  AppSettings.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import Combine
import SwiftUI

/// Represents UI settings to manage and store the state of user interface elements.
///
struct UISettings: Codable {
    
    /// Determines if the security information section is expanded.
    var isSecurityInfoExpand: Bool = true
    
    /// Determines if the snapshot information section is expanded.
    var isSnapshotInfoExpand: Bool = false
    
    /// Determines if the options information section is expanded.
    var isOptionsInfoExpand: Bool = false
    
    /// Determines if the sync information section is expanded.
    var isSyncInfoExpand: Bool = true
}

/// Represents the options/settings related to the application's behavior.
///
struct OptionsSettings: Codable {
    
    /// Indicates whether the application is being launched for the first time.
    var isFirstLaunch: Bool = true
    
    /// The number of last actions to keep track of.
    var keepLastActionsCount: Int = 10
    
    /// Flag to decide if snapshots should be saved to disk.
    var isSaveSnapshotToDisk: Bool = false
    
    /// Determines if the location should be added to snapshots.
    var addLocationToSnapshot: Bool = false
    
    /// Determines if the IP address should be added to snapshots.
    var addIPAddressToSnapshot: Bool = false
    
    /// Determines if a trace route should be added to snapshots.
    var addTraceRouteToSnapshot: Bool = false
    
    /// The server used for trace routing.
    var traceRouteServer: String = ""
    
    /// Flag to indicate if the application settings/data is protected.
    var isProtected: Bool = false
    var authSettings: AuthSettings = .init()
    
}

struct AuthSettings: Codable {
     
    var biometrics = false
    var watch = false
    var devicePassword = false
    
    static var biometricsOrWatch: Self {
        .init(biometrics: true, watch: true, devicePassword: false)
    }
    
}


/// Represents the triggers for capturing snapshots based on various events.
///
struct TriggerSettings: Codable {
    
    /// Capture a snapshot when the device wakes up.
    var isUseSnapshotOnWakeUp: Bool = true
    
    /// Capture a snapshot upon user login.
    var isUseSnapshotOnLogin: Bool = true
    
    /// Capture a snapshot when a wrong password is entered.
    var isUseSnapshotOnWrongPassword: Bool = false
    
    /// Capture a snapshot when switching to battery power.
    var isUseSnapshotOnSwitchToBatteryPower: Bool = false
    
    /// Capture a snapshot when a USB device is mounted.
    var isUseSnapshotOnUSBMount: Bool = false
}

/// Represents settings related to synchronization and storage of snapshots.
///
struct SyncSettings: Codable {
    
    /// Determines if snapshots should be saved to disk.
    var isSaveSnapshotToDisk: Bool = false
    
    /// Determines if notifications should be sent to an email.
    var isSendNotificationToMail: Bool = false
    
    /// The email recipient for sending notifications.
    var mailRecipient: String = ""
    
    /// Flag to enable/disable iCloud sync.
    var isICloudSyncEnable: Bool = true
    
    /// Flag to enable/disable Dropbox sync.
    var isDropboxEnable: Bool = false
    
    /// The name of the Dropbox account (or folder).
    var dropboxName: String = ""
    
    /// Determines if a local notification should be used for snapshots.
    var isUseSnapshotLocalNotification: Bool = false
}

/// Protocol that outlines the properties and methods that app settings should conform to.
protocol AppSettingsProtocol {
    
    /// Flag to indicate if the app is built for Mac App Store.
    static var isMASBuild: Bool { get }
    
    /// Flag to enable/disable image capture debugging.
    static var isImageCaptureDebug: Bool { get }
    
    /// The count of successful launches to determine if it's the app's first launch.
    static var firstLaunchSuccessCount: Int { get }
    
    /// Options/settings related to the application's behavior.
    var options: OptionsSettings { get set }
    
    /// Settings to determine when snapshots should be captured.
    var triggers: TriggerSettings { get set }
    
    /// Settings related to synchronization and storage of snapshots.
    var sync: SyncSettings { get set }
    
    /// Settings to manage and store the state of user interface elements.
    var ui: UISettings { get set }
}

/// Class responsible for managing all settings of the application and storing them in UserDefaults.
final class AppSettings: AppSettingsProtocol {
    
#if NON_MAS_CONFIG
    static var isMASBuild: Bool = false
#else
    static var isMASBuild: Bool = true
#endif
    
    /// Debug flag to check image capturing functionality.
    static var isImageCaptureDebug: Bool = false
    
    /// The default count for successful launches.
    static var firstLaunchSuccessCount = 15
    
    /// Application's behavior settings.
    @UserDefault("OptionsSettings", defaultValue: OptionsSettings())
    var options: OptionsSettings
    
    /// Settings to determine when snapshots should be captured.
    @UserDefault("TriggerSettings", defaultValue: TriggerSettings())
    var triggers: TriggerSettings
    
    /// Settings for syncing and storing snapshots.
    @UserDefault("SyncSettings", defaultValue: SyncSettings())
    var sync: SyncSettings
    
    /// UI settings to remember the state of user interface elements.
    @UserDefault("UISettings", defaultValue: UISettings())
    var ui: UISettings
}


/// class for Preview
/// 
final class AppSettingsPreview: AppSettingsProtocol {
    static var isMASBuild: Bool = true
    
    static var isImageCaptureDebug: Bool = true
    
    static var firstLaunchSuccessCount: Int = 15
    
    var options: OptionsSettings = .init()
    
    var triggers: TriggerSettings = .init()
    
    var sync: SyncSettings = .init()
    
    var ui: UISettings = .init()
}
