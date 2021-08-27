//
//  SettingsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    @EnvironmentObject private var thiefManager: ThiefManager {
        didSet {
            thiefManager.settings = settings
        }
    }
    @EnvironmentObject private var settings: SettingsDto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            VStack(alignment: .leading, spacing: 16.0) {
                LaunchAtLogin.Toggle()
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16.0) {
                UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: $settings.isUseSnapshotOnWakeUp)
                    .onChange(of: settings.isUseSnapshotOnWakeUp, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
                UseSnapshotOnWrongPassword(isUseSnapshotOnWrongPassword: $settings.isUseSnapshotOnWrongPassword)
                    .onChange(of: settings.isUseSnapshotOnWrongPassword, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
                UseSnapshotOnSwitchToBatteryPower(isUseSnapshotOnSwitchToBatteryPower: $settings.isUseSnapshotOnSwitchToBatteryPower)
                    .onChange(of: settings.isUseSnapshotOnSwitchToBatteryPower, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
                UseSnapshotOnUSBMount(isUseSnapshotOnUSBMount: $settings.isUseSnapshotOnUSBMount)
                    .onChange(of: settings.isUseSnapshotOnUSBMount, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
                LastThiefDetection(lastThiefDetection: $thiefManager.lastThiefDetection)
                    .onChange(of: thiefManager.lastThiefDetection.snapshot, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16.0) {
                SendNotificationToMail(isSendNotificationToMail: $settings.isSendNotificationToMail, mailRecipient: $settings.mailRecipient)
                    .onChange(of: settings.isSendNotificationToMail, perform: { value in
                        settings.save()
                    })
                
                ICloudSyncEnableView(isICloudSyncEnable: $settings.isICloudSyncEnable)
                    .onChange(of: settings.isICloudSyncEnable, perform: { value in
                        settings.save()
                    })
                
                DropboxEnableView(isDropboxEnable: $settings.isDropboxEnable, dropboxName: $settings.dropboxName)
                    .onChange(of: settings.isDropboxEnable, perform: { value in
                        settings.save()
                    })
            }
            Divider()
            
            VStack(alignment: .center, spacing: 16.0) {
                ExitView(thiefManager: thiefManager)
            }
        }
        .padding(16.0)
        .frame(width: 350.0)
    }
}

struct UseSnapshotOnWakeUpView: View {
    @Binding var isUseSnapshotOnWakeUp : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnWakeUp) {
            Text("Take Snapshot On WakeUp")
        }
    }
}

struct UseSnapshotOnWrongPassword: View {
    @Binding var isUseSnapshotOnWrongPassword : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnWrongPassword) {
            Text("Take Snapshot On Wrong Password")
        }
    }
}

struct UseSnapshotOnSwitchToBatteryPower: View {
    @Binding var isUseSnapshotOnSwitchToBatteryPower : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnSwitchToBatteryPower) {
            Text("Take Snapshot On Switch To Battery Power")
        }
    }
}

struct UseSnapshotOnUSBMount: View {
    @Binding var isUseSnapshotOnUSBMount : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnUSBMount) {
            Text("Take Snapshot On USB Mount")
        }
    }
}

struct SendNotificationToMail: View {
    @Binding var isSendNotificationToMail : Bool
    @Binding var mailRecipient : String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0, content: {
            Toggle(isOn: $isSendNotificationToMail) {
                Text("Send to Mail")
            }
            TextField("user@example.com", text: $mailRecipient)
                .disabled(isSendNotificationToMail == false)
        })
    }
}

struct ICloudSyncEnableView: View {
    @Binding var isICloudSyncEnable : Bool
    
    var body: some View {
        Toggle(isOn: $isICloudSyncEnable) {
            Text("Sync with iCloud")
        }
    }
}

struct DropboxEnableView: View {
    @Binding var isDropboxEnable : Bool
    @Binding var dropboxName : String
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0, content: {
            
            if let name = dropboxName, name.isEmpty == false {
                Toggle(isOn: $isDropboxEnable) {
                    let text: String = "Sync with Dropbox: \(name)"
                    Text(text)
                }
                Button("logout") {
                    DropboxNotifier.logout()
                    dropboxName = ""
                }
                .disabled(isDropboxEnable == false)
                
            } else {
                Toggle(isOn: $isDropboxEnable) {
                    Text("Sync with Dropbox")
                }
                Button("Authorize") {
                    DropboxNotifier.authorize(on: NSViewController())
                }
                .disabled(isDropboxEnable == false)
            }
        })
    }
}

struct ExitView: View {
    var thiefManager: ThiefManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Quit") {
                exit(0)
            }
            #if DEBUG
            Button("Debug") {
                thiefManager.detectedTriger()
            }
            #endif
        }
    }
}

struct LastThiefDetection: View {
    @Binding var lastThiefDetection : ThiefDto
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            if let img = lastThiefDetection.snapshot, let imageValue = Image(nsImage: img) {
                Divider()
                Text("Last Snapshot:")
                imageValue
                    .resizable()
                    .scaledToFit().frame(width: 300, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("\(lastThiefDetection.date, formatter: Self.taskDateFormat)")
                Divider()
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsDto.current())
            .environmentObject(ThiefManager())
    }
}
