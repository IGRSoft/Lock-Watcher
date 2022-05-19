//
//  SettingsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI

struct SettingsView: View {
    typealias SettingsTrigerWatchBlock = ((TrigerType) -> Void)
    
    @ObservedObject private var thiefManager: ThiefManager
    
    @ObservedObject private var settings = AppSettings()
    
    @State var isInfoHidden = true
    @State var isFirstLaunchHidden = false
    @State var isAccessGranted = false
    
    @State var isInfo1Hidden = false
    
    
    private var accessGrantedBlock: AppEmptyClosure?
        
    func showSnapshot(identifier: String) {
        thiefManager.showSnapshot(identifier: identifier)
    }
    
    init(watchBlock: @escaping SettingsTrigerWatchBlock, accessGrantedBlock: AppEmptyClosure?) {
        self.thiefManager = ThiefManager { dto in
            watchBlock(dto.trigerType)
        }
                
        if settings.isFirstLaunch {
            settings.isFirstLaunch = false
        FirstLaunchView(settings: settings, thiefManager: thiefManager, isHidden: $isFirstLaunchHidden, closeClosure: {
            accessGrantedBlock!()
        }).openInWindow(title: NSLocalizedString("FirstLaunchSetup", comment: ""), sender: self)
        }
    }
    
    var body: some View {
        if !isAccessGranted {
            VStack(alignment: .leading, spacing: 12.0) {
                VStack(alignment: .leading, spacing: 8.0) {
                    LaunchAtLoginView()
                    
                    ProtectionView(isProtectioEnable: $settings.isProtected)
                }
                
                ExtendedDivider(isExtended: $isInfo1Hidden, title: "ddd")
                if !isInfo1Hidden {
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
                }
                
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8.0) {
                    KeepLastCountView(keepLastActionsCount: $settings.keepLastActionsCount)
                    
                    AddLocationToSnapshotView(addLocationToSnapshot: $settings.addLocationToSnapshot)
                        .onChange(of: settings.addLocationToSnapshot, perform: { [weak thiefManager] value in
                            thiefManager?.setupLocationManager(enable: value)
                        })
                    
                    AddIPAddressToSnapshotView(addIPAddressToSnapshot: $settings.addIPAddressToSnapshot)
                    
                    TraceRouteToSnapshotView(isAddTraceRouteToSnapshot: $settings.addTraceRouteToSnapshot, traceRouteServer: $settings.traceRouteServer)
                    
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
        } else {
            Text("")
                .onAppear() {
                    accessGrantedBlock?()
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        //ForEach(["en", "ru", "uk"], id: \.self) { id in
        SettingsView(watchBlock: { _ in }, accessGrantedBlock: {} )
            //.environment(\.locale, .init(identifier: id))
        //}
    }
}
