//
//  SettingsView.swift
//
//  Created on 04.07.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    /// The view model injected via environment.
    @Environment(SettingsViewModel.self) var viewModel

    var body: some View {
        let _ = Self.logViewChanges()
        if viewModel.isAccessGranted {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        LaunchAtLoginView()
                        ProtectionView(isProtectionEnable: viewModel.isProtected, authSettings: viewModel.authSettings, securityUtil: SecurityUtil())
                    }
                    .extended(viewModel.isSecurityInfoExpand, titleKey: "SettingsMenuSecurity")
                }
                .accessibilityIdentifier(AccessibilityID.Settings.securitySection)

                VStack(alignment: .leading) {
                    UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: viewModel.isUseSnapshotOnWakeUp)
                        .onChange(of: viewModel.isUseSnapshotOnWakeUp.wrappedValue) { _, _ in
                            viewModel.restartWatching()
                        }
                    UseSnapshotOnLoginView(isUseSnapshotOnLogin: viewModel.isUseSnapshotOnLogin)
                        .onChange(of: viewModel.isUseSnapshotOnLogin.wrappedValue) { _, _ in
                            viewModel.restartWatching()
                        }
                    if AppSettings.isMASBuild == false {
                        UseSnapshotOnWrongPasswordView(isUseSnapshotOnWrongPassword: viewModel.isUseSnapshotOnWrongPassword)
                            .onChange(of: viewModel.isUseSnapshotOnWrongPassword.wrappedValue) { _, _ in
                                viewModel.restartWatching()
                            }
                    }
                    if DeviceUtil().device() == .laptop {
                        UseSnapshotOnSwitchToBatteryPowerView(isUseSnapshotOnSwitchToBatteryPower: viewModel.isUseSnapshotOnSwitchToBatteryPower)
                            .onChange(of: viewModel.isUseSnapshotOnSwitchToBatteryPower.wrappedValue) { _, _ in
                                viewModel.restartWatching()
                            }
                    }
                    UseSnapshotOnUSBMountView(isUseSnapshotOnUSBMount: viewModel.isUseSnapshotOnUSBMount)
                        .onChange(of: viewModel.isUseSnapshotOnUSBMount.wrappedValue) { _, _ in
                            viewModel.restartWatching()
                        }
                }
                .extended(viewModel.isSnapshotInfoExpand, titleKey: "SettingsMenuSnapshot")
                .accessibilityIdentifier(AccessibilityID.Settings.snapshotSection)

                VStack(alignment: .leading) {
                    KeepLastCountView(keepLastActionsCount: viewModel.keepLastActionsCount)

                    AddLocationToSnapshotView(addLocationToSnapshot: viewModel.addLocationToSnapshot)
                        .onChange(of: viewModel.addLocationToSnapshot.wrappedValue) { _, value in
                            viewModel.setupLocationManager(enable: value)
                        }

                    AddIPAddressToSnapshotView(addIPAddressToSnapshot: viewModel.addIPAddressToSnapshot)

                    TraceRouteToSnapshotView(isAddTraceRouteToSnapshot: viewModel.addTraceRouteToSnapshot, traceRouteServer: viewModel.traceRouteServer)

                    SaveSnapshotToDiskView(isSaveSnapshotToDisk: viewModel.isSaveSnapshotToDisk)
                }
                .extended(viewModel.isOptionsInfoExpand, titleKey: "SettingsMenuOptions")
                .accessibilityIdentifier(AccessibilityID.Settings.optionsSection)

                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                        if AppSettings.isMASBuild == false {
                            SendNotificationToMailView(isSendNotificationToMail: viewModel.isSendNotificationToMail, mailRecipient: viewModel.mailRecipient)
                        }
                        ICloudSyncView(isICloudSyncEnable: viewModel.isICloudSyncEnable)

                        DropboxView(isDropboxEnable: viewModel.isDropboxEnable, dropboxName: viewModel.dropboxName)

                        LocalNotificationView(isLocalNotificationEnable: viewModel.isUseSnapshotLocalNotification)
                    }
                }
                .extended(viewModel.isSyncInfoExpand, titleKey: "SettingsMenuSync")
                .accessibilityIdentifier(AccessibilityID.Settings.syncSection)
            }
            .padding(viewModel.viewSettings.border)
            .frame(width: viewModel.viewSettings.window.width)
            .accessibilityIdentifier(AccessibilityID.Settings.container)
        } else {
            Text("")
                .onAppear {
                    viewModel.accessGrantedBlock?()
                }
        }
    }
}

#Preview("Settings View") {
    SettingsView()
        .environment(SettingsViewModel.preview)
}
