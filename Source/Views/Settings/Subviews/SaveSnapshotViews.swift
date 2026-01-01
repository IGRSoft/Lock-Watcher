//
//  SaveSnapshotViews.swift
//
//  Created on 26.12.2021.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view component that allows the user to determine the number of last actions to keep.
struct KeepLastCountView: View {
    @Binding var keepLastActionsCount: Int

    var body: some View {
        Stepper(value: $keepLastActionsCount, in: 1 ... 30) {
            Text(String(format: NSLocalizedString("KeepLastN %d", comment: ""), keepLastActionsCount))
        }
        .accessibilityIdentifier(AccessibilityID.Settings.keepLastStepper)
        .accessibilityLabel(AccessibilityLabel.Settings.keepLast(keepLastActionsCount))
    }
}

/// A view component that allows the user to toggle whether to send notifications via email,
/// and to specify the recipient email.
struct SendNotificationToMailView: View {
    @Binding var isSendNotificationToMail: Bool
    @Binding var mailRecipient: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Toggle(isOn: $isSendNotificationToMail) {
                Text("SendToMail")
            }
            .accessibilityIdentifier(AccessibilityID.Settings.emailToggle)
            .accessibilityLabel(AccessibilityLabel.Settings.sendEmail)
            .accessibilityHint(AccessibilityHint.Settings.toggleHint)

            TextField("user@example.com", text: $mailRecipient)
                .disabled(isSendNotificationToMail == false)
                .accessibilityIdentifier(AccessibilityID.Settings.emailField)
        }
    }
}

/// A view component that allows the user to toggle whether to add location information to the snapshot.
struct AddLocationToSnapshotView: View {
    @Binding var addLocationToSnapshot: Bool

    @State private var showingAlert = false

    var body: some View {
        Toggle(isOn: $addLocationToSnapshot) {
            Text("AddLocationToSnapshot")
        }
        .onChange(of: addLocationToSnapshot) { _, value in
            if value {
                PermissionsUtils.updateLocationPermissions { [self] isGranted in
                    Task { @MainActor in
                        showingAlert = !isGranted
                    }
                }
            }
        }
        .alert("OpenSettings", isPresented: $showingAlert) {
            Button("ButtonSettings") {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!)
                addLocationToSnapshot = false
            }
            Button("ButtonCancel", role: .cancel) {
                addLocationToSnapshot = false
            }
        }
        .accessibilityIdentifier(AccessibilityID.Settings.locationToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.addLocation)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}

/// A view component that allows the user to toggle whether to add IP address information to the snapshot.
struct AddIPAddressToSnapshotView: View {
    @Binding var addIPAddressToSnapshot: Bool

    var body: some View {
        Toggle(isOn: $addIPAddressToSnapshot) {
            Text("AddIPAddressToSnapshot")
        }
        .accessibilityIdentifier(AccessibilityID.Settings.ipAddressToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.addIPAddress)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}

/// A view component that allows the user to toggle whether to add a traceroute to the snapshot,
/// and to specify the traceroute server.
struct TraceRouteToSnapshotView: View {
    @Binding var isAddTraceRouteToSnapshot: Bool
    @Binding var traceRouteServer: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            Toggle(isOn: $isAddTraceRouteToSnapshot) {
                Text("AddTraceRoute")
            }
            .accessibilityIdentifier(AccessibilityID.Settings.traceRouteToggle)
            .accessibilityLabel(AccessibilityLabel.Settings.addTraceRoute)
            .accessibilityHint(AccessibilityHint.Settings.toggleHint)

            TextField("example.com", text: $traceRouteServer)
                .disabled(isAddTraceRouteToSnapshot == false)
                .accessibilityIdentifier(AccessibilityID.Settings.traceRouteServerField)
        }
    }
}

/// A view component that allows the user to toggle whether to save the snapshot to disk.
struct SaveSnapshotToDiskView: View {
    @Binding var isSaveSnapshotToDisk: Bool

    var body: some View {
        Toggle(isOn: $isSaveSnapshotToDisk) {
            Text("SaveSnapshotToDisk")
        }
        .accessibilityIdentifier(AccessibilityID.Settings.saveToDiskToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.saveToDisk)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}

/// A view component that allows the user to toggle iCloud synchronization.
struct ICloudSyncView: View {
    @Binding var isICloudSyncEnable: Bool

    var body: some View {
        Toggle(isOn: $isICloudSyncEnable) {
            Text("SyncWithiCloud")
        }
        .disabled(FileManager.default.ubiquityIdentityToken == nil)
        .help("SyncWithiCloudHelp")
        .accessibilityIdentifier(AccessibilityID.Settings.iCloudToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.syncICloud)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}

/// A view component that provides options for synchronizing with Dropbox.
/// It shows different options based on whether the user is already authenticated with Dropbox.
struct DropboxView: View {
    @Binding var isDropboxEnable: Bool
    @Binding var dropboxName: String

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.sm) {
            if dropboxName.isEmpty == false {
                Toggle(isOn: $isDropboxEnable) {
                    Text(String(format: NSLocalizedString("SyncedWithDropbox %@", comment: ""), dropboxName))
                }
                .accessibilityIdentifier(AccessibilityID.Settings.dropboxToggle)
                .accessibilityLabel(AccessibilityLabel.Settings.syncDropbox)

                Button("Logout") {
                    DropboxNotifier.logout()
                    dropboxName = ""
                }
                .disabled(isDropboxEnable == false)
                .accessibilityIdentifier(AccessibilityID.Settings.dropboxLogoutButton)

            } else {
                Toggle(isOn: $isDropboxEnable) {
                    Text("SyncWithDropbox")
                }
                .accessibilityIdentifier(AccessibilityID.Settings.dropboxToggle)
                .accessibilityLabel(AccessibilityLabel.Settings.syncDropbox)
                .accessibilityHint(AccessibilityHint.Settings.toggleHint)

                Button("Authorize") {
                    DropboxNotifier.authorize(on: NSViewController())
                }
                .disabled(isDropboxEnable == false)
                .accessibilityIdentifier(AccessibilityID.Settings.dropboxAuthButton)
            }
        }
    }
}

/// A view component that allows the user to toggle local notifications.
struct LocalNotificationView: View {
    @Binding var isLocalNotificationEnable: Bool

    var body: some View {
        Toggle(isOn: $isLocalNotificationEnable) {
            Text("PushLocalNotification")
        }
        .accessibilityIdentifier(AccessibilityID.Settings.notificationToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.localNotification)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}
