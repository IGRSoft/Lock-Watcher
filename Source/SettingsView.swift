//
//  SettingsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI

struct SettingsView: View {
    private struct K {
        static let windowWidth: CGFloat = 340
        static let windowBorder = EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        static let blockWidth = windowWidth - (windowBorder.leading + windowBorder.trailing)
    }
    
    typealias SettingsTriggerWatchBlock = ((TriggerType) -> Void)
    
    @ObservedObject private(set) var thiefManager: ThiefManager
    
    @ObservedObject private var settings: AppSettings
    
    @State var isInfoHidden = true
    @State var isAccessGranted = false
    
    private var accessGrantedBlock: AppEmptyClosure?
    
    func showSnapshot(identifier: String) {
        thiefManager.showSnapshot(identifier: identifier)
    }
    
    init(settings: AppSettings, watchBlock: @escaping SettingsTriggerWatchBlock) {
        self.settings = settings
        
        thiefManager = ThiefManager(settings: settings) { dto in
            watchBlock(dto.triggerType)
        }
    }
    
    var body: some View {
        if !isAccessGranted {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    ExtendedDivider(isExtended: $settings.ui.isSecurityInfoHidden, title: "SettingsMenuSecurity")
                    if !settings.ui.isSecurityInfoHidden {
                        VStack(alignment: .leading, spacing: 8.0) {
                            LaunchAtLoginView()
                            
                            ProtectionView(isProtectionEnable: $settings.options.isProtected)
                        }
                    }
                }
                .frame(width: K.blockWidth)
                
                VStack(alignment: .leading) {
                    ExtendedDivider(isExtended: $settings.ui.isSnapshotInfoHidden, title: "SettingsMenuSnapshot")
                    if !settings.ui.isSnapshotInfoHidden {
                        VStack(alignment: .leading, spacing: 8.0) {
                            UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: $settings.triggers.isUseSnapshotOnWakeUp)
                                .onChange(of: settings.triggers.isUseSnapshotOnWakeUp, perform: { [weak thiefManager] value in
                                    thiefManager?.restartWatching()
                                })
                            UseSnapshotOnLoginView(isUseSnapshotOnLogin: $settings.triggers.isUseSnapshotOnLogin)
                                .onChange(of: settings.triggers.isUseSnapshotOnLogin, perform: { [weak thiefManager] value in
                                    thiefManager?.restartWatching()
                                })
                            if AppSettings.isMASBuild == false {
                                UseSnapshotOnWrongPasswordView(isUseSnapshotOnWrongPassword: $settings.triggers.isUseSnapshotOnWrongPassword)
                                    .onChange(of: settings.triggers.isUseSnapshotOnWrongPassword, perform: { [weak thiefManager] value in
                                        thiefManager?.restartWatching()
                                    })
                            }
                            if DeviceUtil.device() == .laptop {
                                UseSnapshotOnSwitchToBatteryPowerView(isUseSnapshotOnSwitchToBatteryPower: $settings.triggers.isUseSnapshotOnSwitchToBatteryPower)
                                    .onChange(of: settings.triggers.isUseSnapshotOnSwitchToBatteryPower, perform: { [weak thiefManager] value in
                                        thiefManager?.restartWatching()
                                    })
                            }
                            UseSnapshotOnUSBMountView(isUseSnapshotOnUSBMount: $settings.triggers.isUseSnapshotOnUSBMount)
                                .onChange(of: settings.triggers.isUseSnapshotOnUSBMount, perform: { [weak thiefManager] value in
                                    thiefManager?.restartWatching()
                                })
                        }
                    }
                }
                .frame(width: K.blockWidth)
                
                VStack(alignment: .leading) {
                    ExtendedDivider(isExtended: $settings.ui.isOptionsInfoHidden, title: "SettingsMenuOptions")
                    if !settings.ui.isOptionsInfoHidden {
                        VStack(alignment: .leading, spacing: 8.0) {
                            KeepLastCountView(keepLastActionsCount: $settings.options.keepLastActionsCount)
                            
                            AddLocationToSnapshotView(addLocationToSnapshot: $settings.options.addLocationToSnapshot)
                                .onChange(of: settings.options.addLocationToSnapshot, perform: { [weak thiefManager] value in
                                    thiefManager?.setupLocationManager(enable: value)
                                })
                            
                            AddIPAddressToSnapshotView(addIPAddressToSnapshot: $settings.options.addIPAddressToSnapshot)
                            
                            TraceRouteToSnapshotView(isAddTraceRouteToSnapshot: $settings.options.addTraceRouteToSnapshot, traceRouteServer: $settings.options.traceRouteServer)
                            
                            SaveSnapshotToDiskView(isSaveSnapshotToDisk: $settings.sync.isSaveSnapshotToDisk)
                        }
                    }
                }
                .frame(width: K.blockWidth)
                
                VStack(alignment: .leading) {
                    ExtendedDivider(isExtended: $settings.ui.isSyncInfoHidden, title: "SettingsMenuSync")
                    if !settings.ui.isSyncInfoHidden {
                        
                        VStack(alignment: .leading, spacing: 8.0) {
                            if AppSettings.isMASBuild == false {
                                SendNotificationToMailView(isSendNotificationToMail: $settings.sync.isSendNotificationToMail, mailRecipient: $settings.sync.mailRecipient)
                                    .onChange(of: settings.sync.isSendNotificationToMail, perform: {_ in })
                            }
                            ICloudSyncView(isICloudSyncEnable: $settings.sync.isICloudSyncEnable)
                            
                            DropboxView(isDropboxEnable: $settings.sync.isDropboxEnable, dropboxName: $settings.sync.dropboxName)
                            
                            LocalNotificationView(isLocalNotificationEnable: $settings.sync.isUseSnapshotLocalNotification)
                        }
                    }
                }
                .frame(width: K.blockWidth)
                
                VStack(alignment: .leading) {
                    LastThiefDetectionView(databaseManager: $thiefManager.databaseManager)
                }
                .frame(width: K.blockWidth)
                
                VStack(alignment: .leading) {
                    InfoView(thiefManager: thiefManager, isInfoHidden: $isInfoHidden)
                }
                .frame(width: K.blockWidth)
            }
            .padding(K.windowBorder)
            .frame(width: K.windowWidth)
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
        SettingsView(settings: AppSettings(), watchBlock: { _ in } )
        //.environment(\.locale, .init(identifier: id))
        //}
    }
}
