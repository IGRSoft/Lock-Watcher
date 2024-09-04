//
//  SaveSnapshotViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import SwiftUI

/// A view component that allows the user to determine the number of last actions to keep.
struct KeepLastCountView: View {
    @Binding var keepLastActionsCount : Int
    
    var body: some View {
        Stepper(value: $keepLastActionsCount, in: 1...30) {
            Text(String(format: NSLocalizedString("KeepLastN %d", comment: ""), keepLastActionsCount))
        }
    }
}

/// A view component that allows the user to toggle whether to send notifications via email,
/// and to specify the recipient email.
struct SendNotificationToMailView: View {
    @Binding var isSendNotificationToMail : Bool
    @Binding var mailRecipient : String
    
    var body: some View {
        HStack(spacing: ViewConstants.spacing, content: {
            Toggle(isOn: $isSendNotificationToMail) {
                Text("SendToMail")
            }
            TextField("user@example.com", text: $mailRecipient)
                .disabled(isSendNotificationToMail == false)
        })
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
        .onChange(of: addLocationToSnapshot) { value in
            if value {
                PermissionsUtils.updateLocationPermissions { isGranted in
                    showingAlert = !isGranted
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
    }
}

/// A view component that allows the user to toggle whether to add IP address information to the snapshot.
struct AddIPAddressToSnapshotView: View {
    @Binding var addIPAddressToSnapshot : Bool
    
    var body: some View {
        Toggle(isOn: $addIPAddressToSnapshot) {
            Text("AddIPAddressToSnapshot")
        }
    }
}

/// A view component that allows the user to toggle whether to add a traceroute to the snapshot,
/// and to specify the traceroute server.
struct TraceRouteToSnapshotView: View {
    @Binding var isAddTraceRouteToSnapshot : Bool
    @Binding var traceRouteServer : String
    
    var body: some View {
        HStack(spacing: ViewConstants.spacing, content: {
            Toggle(isOn: $isAddTraceRouteToSnapshot) {
                Text("AddTraceRoute")
            }
            TextField("example.com", text: $traceRouteServer)
                .disabled(isAddTraceRouteToSnapshot == false)
        })
    }
}

/// A view component that allows the user to toggle whether to save the snapshot to disk.
struct SaveSnapshotToDiskView: View {
    @Binding var isSaveSnapshotToDisk : Bool
    
    var body: some View {
        Toggle(isOn: $isSaveSnapshotToDisk) {
            Text("SaveSnapshotToDisk")
        }
    }
}

/// A view component that allows the user to toggle iCloud synchronization.
struct ICloudSyncView: View {
    @Binding var isICloudSyncEnable : Bool
    
    var body: some View {
        Toggle(isOn: $isICloudSyncEnable) {
            Text("SyncWithiCloud")
        }
        .disabled(FileManager.default.ubiquityIdentityToken == nil)
        .help("SyncWithiCloudHelp")
    }
}

/// A view component that provides options for synchronizing with Dropbox.
/// It shows different options based on whether the user is already authenticated with Dropbox.
struct DropboxView: View {
    @Binding var isDropboxEnable : Bool
    @Binding var dropboxName : String
    
    var body: some View {
        HStack(spacing: ViewConstants.spacing, content: {
            
            if dropboxName.isEmpty == false {
                Toggle(isOn: $isDropboxEnable) {
                    Text(String(format: NSLocalizedString("SyncedWithDropbox %@", comment: ""), dropboxName))
                }
                Button("Logout") {
                    DropboxNotifier.logout()
                    dropboxName = ""
                }
                .disabled(isDropboxEnable == false)
                
            } else {
                Toggle(isOn: $isDropboxEnable) {
                    Text("SyncWithDropbox")
                }
                Button("Authorize") {
                    DropboxNotifier.authorize(on: NSViewController())
                }
                .disabled(isDropboxEnable == false)
            }
        })
    }
}

/// A view component that allows the user to toggle local notifications.
struct LocalNotificationView: View {
    @Binding var isLocalNotificationEnable : Bool
    
    var body: some View {
        Toggle(isOn: $isLocalNotificationEnable) {
            Text("PushLocalNotification")
        }
    }
}
