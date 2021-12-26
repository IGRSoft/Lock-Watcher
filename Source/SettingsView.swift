//
//  SettingsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    typealias SettingsTrigerWatchBlock = ((TrigerType) -> Void)
            
    @ObservedObject private var thiefManager: ThiefManager
    
    @ObservedObject private var settings = AppSettings()
    
    @State var isInfoHidden = true
    
    func showSnapshot(identifier: String) {
        thiefManager.showSnapshot(identifier: identifier)
    }
    
    init(watchBlock: @escaping SettingsTrigerWatchBlock) {
        self.thiefManager = ThiefManager { dto in
            watchBlock(dto.trigerType)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            VStack(spacing: 16.0) {
                LaunchAtLogin.Toggle(LocalizedStringKey("LaunchAtLogin"))
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8.0) {
                UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: $settings.isUseSnapshotOnWakeUp)
                    .onChange(of: settings.isUseSnapshotOnWakeUp, perform: { [weak thiefManager] value in
                        thiefManager?.restartWatching()
                    })
                UseSnapshotOnLoginView(isUseSnapshotOnLogin: $settings.isUseSnapshotOnLogin)
                    .onChange(of: settings.isUseSnapshotOnLogin, perform: { [weak thiefManager] value in
                        thiefManager?.restartWatching()
                    })
                if AppSettings.isMASBuild == false {
                    UseSnapshotOnWrongPasswordView(isUseSnapshotOnWrongPassword: $settings.isUseSnapshotOnWrongPassword)
                        .onChange(of: settings.isUseSnapshotOnWrongPassword, perform: { [weak thiefManager] value in
                            thiefManager?.restartWatching()
                        })
                }
                UseSnapshotOnSwitchToBatteryPowerView(isUseSnapshotOnSwitchToBatteryPower: $settings.isUseSnapshotOnSwitchToBatteryPower)
                    .onChange(of: settings.isUseSnapshotOnSwitchToBatteryPower, perform: { [weak thiefManager] value in
                        thiefManager?.restartWatching()
                    })
                UseSnapshotOnUSBMountView(isUseSnapshotOnUSBMount: $settings.isUseSnapshotOnUSBMount)
                    .onChange(of: settings.isUseSnapshotOnUSBMount, perform: { [weak thiefManager] value in
                        thiefManager?.restartWatching()
                    })
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8.0) {
                KeepLastCountView(keepLastActionsCount: $settings.keepLastActionsCount)
                
                AddLocationToSnapshotView(addLocationToSnapshot: $settings.addLocationToSnapshot)
                    .onChange(of: settings.addLocationToSnapshot, perform: { [weak thiefManager] value in
                        thiefManager?.setupLocationManager(enable: value)
                    })
                
                SaveSnapshotToDiskView(isSaveSnapshotToDisk: $settings.isSaveSnapshotToDisk)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8.0) {
                if AppSettings.isMASBuild == false {
                    SendNotificationToMailView(isSendNotificationToMail: $settings.isSendNotificationToMail, mailRecipient: $settings.mailRecipient)
                        .onChange(of: settings.isSendNotificationToMail, perform: {_ in })
                }
                ICloudSyncView(isICloudSyncEnable: $settings.isICloudSyncEnable)
                
                DropboxView(isDropboxEnable: $settings.isDropboxEnable, dropboxName: $settings.dropboxName)
                
                LocalNotificationView(isLocalNotificationEnable: $settings.isUseSnapshotLocalNotification)
            }
            Divider()
            
            LastThiefDetectionView(databaseManager: $thiefManager.databaseManager)
            
            VStack() {
                InfoView(thiefManager: thiefManager, isInfoHidden: $isInfoHidden)
            }
            .frame(width: 324.0)
        }
        .padding(16.0)
        .frame(width: 340.0)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        //ForEach(["en", "ru", "uk"], id: \.self) { id in
        SettingsView(watchBlock: { _ in } )
                //.environment(\.locale, .init(identifier: id))
        //}
    }
}
