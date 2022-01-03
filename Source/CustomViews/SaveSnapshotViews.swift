//
//  SaveSnapshotViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import SwiftUI

struct KeepLastCountView: View {
    @Binding var keepLastActionsCount : Int
    
    var body: some View {
        Stepper(value: $keepLastActionsCount, in: 1...30) {
            Text(Translation.keep(last: keepLastActionsCount))
        }
    }
}

struct SendNotificationToMailView: View {
    @Binding var isSendNotificationToMail : Bool
    @Binding var mailRecipient : String
    
    var body: some View {
        HStack(spacing: 8.0, content: {
            Toggle(isOn: $isSendNotificationToMail) {
                Text("SendToMail")
            }
            TextField("user@example.com", text: $mailRecipient)
                .disabled(isSendNotificationToMail == false)
        })
    }
}

struct AddLocationToSnapshotView: View {
    @Binding var addLocationToSnapshot : Bool
    
    var body: some View {
        Toggle(isOn: $addLocationToSnapshot) {
            Text("AddLocationToSnapshot")
        }
    }
}

struct AddIPAddressToSnapshotView: View {
    @Binding var addIPAddressToSnapshot : Bool
    
    var body: some View {
        Toggle(isOn: $addIPAddressToSnapshot) {
            Text("AddIPAddressToSnapshot")
        }
    }
}

struct SaveSnapshotToDiskView: View {
    @Binding var isSaveSnapshotToDisk : Bool
    
    var body: some View {
        Toggle(isOn: $isSaveSnapshotToDisk) {
            Text("SaveSnapshotToDisk")
        }
    }
}

struct ICloudSyncView: View {
    @Binding var isICloudSyncEnable : Bool
    
    var body: some View {
        Toggle(isOn: $isICloudSyncEnable) {
            Text("SyncWithiCloud")
        }
    }
}

struct DropboxView: View {
    @Binding var isDropboxEnable : Bool
    @Binding var dropboxName : String
    
    var body: some View {
        HStack(spacing: 8.0, content: {
            
            if let name = dropboxName, name.isEmpty == false {
                Toggle(isOn: $isDropboxEnable) {
                    let text = Translation.synkedDropbox(name: name)
                    Text(text)
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

struct LocalNotificationView: View {
    @Binding var isLocalNotificationEnable : Bool
    
    var body: some View {
        Toggle(isOn: $isLocalNotificationEnable) {
            Text("PushLocalNotification")
        }
    }
}
