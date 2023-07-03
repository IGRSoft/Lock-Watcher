//
//  SettingsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        let _ = Self._printChanges()
        
        if viewModel.isAccessGranted {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        LaunchAtLoginView()
                        
                        ProtectionView(isProtectionEnable: viewModel.isProtected)
                    }.extended(viewModel.isSecurityInfoExpand, titleKey: "SettingsMenuSecurity")
                }
                
                VStack(alignment: .leading) {
                    UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: viewModel.isUseSnapshotOnWakeUp)
                        .onChange(of: viewModel.isUseSnapshotOnWakeUp.wrappedValue, perform: { [weak thiefManager = viewModel.thiefManager] value in
                            thiefManager?.restartWatching()
                        })
                    UseSnapshotOnLoginView(isUseSnapshotOnLogin: viewModel.isUseSnapshotOnLogin)
                        .onChange(of: viewModel.isUseSnapshotOnLogin.wrappedValue, perform: { [weak thiefManager = viewModel.thiefManager] value in
                            thiefManager?.restartWatching()
                        })
                    if AppSettings.isMASBuild == false {
                        UseSnapshotOnWrongPasswordView(isUseSnapshotOnWrongPassword: viewModel.isUseSnapshotOnWrongPassword)
                            .onChange(of: viewModel.isUseSnapshotOnWrongPassword.wrappedValue, perform: { [weak thiefManager = viewModel.thiefManager] value in
                                thiefManager?.restartWatching()
                            })
                    }
                    if DeviceUtil.device() == .laptop {
                        UseSnapshotOnSwitchToBatteryPowerView(isUseSnapshotOnSwitchToBatteryPower: viewModel.isUseSnapshotOnSwitchToBatteryPower)
                            .onChange(of: viewModel.isUseSnapshotOnSwitchToBatteryPower.wrappedValue, perform: { [weak thiefManager = viewModel.thiefManager] value in
                                thiefManager?.restartWatching()
                            })
                    }
                    UseSnapshotOnUSBMountView(isUseSnapshotOnUSBMount: viewModel.isUseSnapshotOnUSBMount)
                        .onChange(of: viewModel.isUseSnapshotOnUSBMount.wrappedValue, perform: { [weak thiefManager = viewModel.thiefManager] value in
                            thiefManager?.restartWatching()
                        })
                }
                .extended(viewModel.isSnapshotInfoExpand, titleKey: "SettingsMenuSnapshot")
                
                VStack(alignment: .leading) {
                    KeepLastCountView(keepLastActionsCount: viewModel.keepLastActionsCount)
                    
                    AddLocationToSnapshotView(addLocationToSnapshot: viewModel.addLocationToSnapshot)
                        .onChange(of: viewModel.addLocationToSnapshot.wrappedValue, perform: { [weak thiefManager = viewModel.thiefManager] value in
                            thiefManager?.setupLocationManager(enable: value)
                        })
                    
                    AddIPAddressToSnapshotView(addIPAddressToSnapshot: viewModel.addIPAddressToSnapshot)
                    
                    TraceRouteToSnapshotView(isAddTraceRouteToSnapshot: viewModel.addTraceRouteToSnapshot, traceRouteServer: viewModel.traceRouteServer)
                    
                    SaveSnapshotToDiskView(isSaveSnapshotToDisk: viewModel.isSaveSnapshotToDisk)
                }
                .extended(viewModel.isOptionsInfoExpand, titleKey: "SettingsMenuOptions")
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 8.0) {
                        if AppSettings.isMASBuild == false {
                            SendNotificationToMailView(isSendNotificationToMail: viewModel.isSendNotificationToMail, mailRecipient: viewModel.mailRecipient)
                                .onChange(of: viewModel.isSendNotificationToMail.wrappedValue, perform: {_ in })
                        }
                        ICloudSyncView(isICloudSyncEnable: viewModel.isICloudSyncEnable)
                        
                        DropboxView(isDropboxEnable: viewModel.isDropboxEnable, dropboxName: viewModel.dropboxName)
                        
                        LocalNotificationView(isLocalNotificationEnable: viewModel.isUseSnapshotLocalNotification)
                    }
                }
                .extended(viewModel.isSyncInfoExpand, titleKey: "SettingsMenuSync")
            }
            .padding(viewModel.viewSettings.border)
            .frame(width: viewModel.viewSettings.window.width)
        } else {
            Text("")
                .onAppear() {
                    viewModel.accessGrantedBlock?()
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        //ForEach(["en", "ru", "uk"], id: \.self) { id in
        SettingsView(viewModel: SettingsViewModel(settings: AppSettings(), thiefManager: ThiefManager(settings: AppSettings())))
        //.environment(\.locale, .init(identifier: id))
        //}
    }
}
