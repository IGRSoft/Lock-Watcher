//
//  SettingsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI
import LaunchAtLogin

enum Translation {
    static func keep(last: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("Keep last %d", comment: ""), last)
    }
    static func synkedDropbox(name: String) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("Synced with Dropbox: %@", comment: ""), name)
    }
}

struct SettingsView: View {
    @EnvironmentObject private var thiefManager: ThiefManager {
        didSet {
            thiefManager.settings = settings
        }
    }
    @EnvironmentObject private var settings: SettingsDto
    
    @State var isInfoHidden = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            VStack(spacing: 16.0) {
                LaunchAtLogin.Toggle(LocalizedStringKey("LaunchAtLogin"))
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8.0) {
                UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: $settings.isUseSnapshotOnWakeUp)
                    .onChange(of: settings.isUseSnapshotOnWakeUp, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
                UseSnapshotOnWrongPasswordView(isUseSnapshotOnWrongPassword: $settings.isUseSnapshotOnWrongPassword)
                    .onChange(of: settings.isUseSnapshotOnWrongPassword, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
                UseSnapshotOnSwitchToBatteryPowerView(isUseSnapshotOnSwitchToBatteryPower: $settings.isUseSnapshotOnSwitchToBatteryPower)
                    .onChange(of: settings.isUseSnapshotOnSwitchToBatteryPower, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
                UseSnapshotOnUSBMountView(isUseSnapshotOnUSBMount: $settings.isUseSnapshotOnUSBMount)
                    .onChange(of: settings.isUseSnapshotOnUSBMount, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
                KeepLastCountView(keepLastActionsCount: $settings.keepLastActionsCount)
                    .onChange(of: thiefManager.lastThiefDetection.snapshot, perform: { value in
                        settings.save()
                    })
                LastThiefDetectionView(lastThiefDetection: $thiefManager.lastThiefDetection)
                    .onChange(of: thiefManager.lastThiefDetection.snapshot, perform: { value in
                        thiefManager.restartWatching()
                        settings.save()
                    })
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8.0) {
                SendNotificationToMailView(isSendNotificationToMail: $settings.isSendNotificationToMail, mailRecipient: $settings.mailRecipient)
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
            
            VStack() {
                InfoView(thiefManager: thiefManager, isInfoHidden: $isInfoHidden)
            }
            .frame(width: 324.0)
        }
        .padding(16.0)
        .frame(width: 340.0)
    }
}

struct UseSnapshotOnWakeUpView: View {
    @Binding var isUseSnapshotOnWakeUp : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnWakeUp) {
            Text("SnapshotOnWakeUp")
        }
    }
}

struct UseSnapshotOnWrongPasswordView: View {
    @Binding var isUseSnapshotOnWrongPassword : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnWrongPassword) {
            Text("SnapshotOnWrongPassword")
        }
    }
}

struct UseSnapshotOnSwitchToBatteryPowerView: View {
    @Binding var isUseSnapshotOnSwitchToBatteryPower : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnSwitchToBatteryPower) {
            Text("SnapshotOnSwitchToBatteryPower")
        }
    }
}

struct UseSnapshotOnUSBMountView: View {
    @Binding var isUseSnapshotOnUSBMount : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnUSBMount) {
            Text("SnapshotOnUSBMount")
        }
    }
}

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

struct ICloudSyncEnableView: View {
    @Binding var isICloudSyncEnable : Bool
    
    var body: some View {
        Toggle(isOn: $isICloudSyncEnable) {
            Text("SyncWithiCloud")
        }
    }
}

struct DropboxEnableView: View {
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

struct InfoView: View {
    var thiefManager: ThiefManager
    
    @Binding var isInfoHidden: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            if isInfoHidden {
                Button("􀁹") {
                    isInfoHidden = false
                }.buttonStyle(BorderlessButtonStyle())
            } else {
                Button("􀁷") {
                    isInfoHidden = true
                }.buttonStyle(BorderlessButtonStyle())
                
                VStack(alignment: .center) {
                    #if DEBUG
                    Button("Debug") {
                        thiefManager.detectedTriger()
                    }
                    #endif
                    
                    Button("LastSnapshots") {
                        //add preview
                        thiefManager.databaseManager.latestImages()
                    }
                    Button("Notices") {
                        exit(0)
                    }
                    Button("Quit") {
                        exit(0)
                    }
                    Text("© IGR Software 2008 - 2021")
                }
            }
        }
    }
}

struct LastThiefDetectionView: View {
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
                Text("LastSnapshot")
                imageValue
                    .resizable()
                    .scaledToFit().frame(width: 300, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        if let filepath = lastThiefDetection.filepath {
                            NSWorkspace.shared.open(filepath)
                        }
                    }
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
