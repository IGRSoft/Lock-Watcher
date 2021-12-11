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
    @ObservedObject private var thiefManager = ThiefManager { _ in }
    
    @ObservedObject private var settings = AppSettings()
    
    @State var isInfoHidden = true
    
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
                ICloudSyncEnableView(isICloudSyncEnable: $settings.isICloudSyncEnable)
                
                DropboxEnableView(isDropboxEnable: $settings.isDropboxEnable, dropboxName: $settings.dropboxName)
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

struct UseSnapshotOnWakeUpView: View {
    @Binding var isUseSnapshotOnWakeUp : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnWakeUp) {
            Text("SnapshotOnWakeUp")
        }
    }
}

struct UseSnapshotOnLoginView: View {
    @Binding var isUseSnapshotOnLogin : Bool
    
    var body: some View {
        Toggle(isOn: $isUseSnapshotOnLogin) {
            Text("SnapshotOnLogin")
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

struct AddLocationToSnapshotView: View {
    @Binding var addLocationToSnapshot : Bool
    
    var body: some View {
        Toggle(isOn: $addLocationToSnapshot) {
            Text("AddLocationToSnapshot")
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
                Button(action: {
                    isInfoHidden = false
                }) {
                    Image(systemName: "chevron.compact.down").font(.system(size: 28))
                }.buttonStyle(BorderlessButtonStyle())
            } else {
                Button(action: {
                    isInfoHidden = true
                }) {
                    Image(systemName: "chevron.compact.up").font(.system(size: 28))
                }.buttonStyle(BorderlessButtonStyle())
                
                VStack(alignment: .center) {
#if DEBUG
                    Button("Debug") {
                        thiefManager.detectedTriger()
                    }
#endif
                    
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
    @Binding var databaseManager: DatabaseManager
    @State var isPreviewActive: Bool = false
    
    var body: some View {
        let latestImages = databaseManager.latestImages()
        
        VStack(alignment: .center, spacing: 8.0) {
            if let lastImage = latestImages.dtos.last,
               let imageData = lastImage.data,
               let image = NSImage(data: imageData),
               let imageValue = Image(nsImage: image),
               let date = lastImage.date {
                Text("LastSnapshot")
                imageValue
                    .resizable()
                    .scaledToFit().frame(width: 324, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        if let filepath = lastImage.path {
                            NSWorkspace.shared.open(filepath)
                        }
                    }
                Text("\(date, formatter: Date.dateFormat)")
                if latestImages.dtos.count > 1 {
                    Button("LastSnapshots") {
                        isPreviewActive = true
                    }
                    .popover(isPresented: $isPreviewActive, arrowEdge: .leading) {
                        Preview()
                            .frame(width: 168 * 4, height: 126.0 * ceil(Double(latestImages.dtos.count) / 4.0) + 36.0, alignment: .center)
                            .environmentObject(latestImages)
                    }
                }
                
                Divider()
            }
        }
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        //ForEach(["en", "ru", "uk"], id: \.self) { id in
            SettingsView()
                //.environment(\.locale, .init(identifier: id))
        //}
    }
}
