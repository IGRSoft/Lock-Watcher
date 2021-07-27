//
//  SettingsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    @ObservedObject private var thiefManager = ThiefManager()
    //@ObservedObject private var image = thiefManager.lastThiefDetection.$snapshot
    
    //@State private var image: Image?
    @State private var dateText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            LaunchAtLogin.Toggle()
            Divider()
            UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: $thiefManager.settings.isUseSnapshotOnWakeUp)
                .onChange(of: thiefManager.settings.isUseSnapshotOnWakeUp, perform: { value in
                    thiefManager.restartWatching()
                })
            UseSnapshotOnWrongPassword(isUseSnapshotOnWrongPassword: $thiefManager.settings.isUseSnapshotOnWrongPassword)
                .onChange(of: thiefManager.settings.isUseSnapshotOnWrongPassword, perform: { value in
                    thiefManager.restartWatching()
                })
            UseSnapshotOnSwitchToBatteryPower(isUseSnapshotOnSwitchToBatteryPower: $thiefManager.settings.isUseSnapshotOnSwitchToBatteryPower)
                .onChange(of: thiefManager.settings.isUseSnapshotOnSwitchToBatteryPower, perform: { value in
                    thiefManager.restartWatching()
                })
            HStack(alignment: .center, spacing: 16.0, content: {
                Toggle(isOn: $thiefManager.settings.isSendNotificationToMail) {
                    Text("Send to Mail")
                }
                TextField("user@example.com", text: $thiefManager.settings.mailRecipient)
                    .disabled(thiefManager.settings.isSendNotificationToMail == false)
            })
            
            VStack(alignment: .leading, spacing: 16.0) {
                if let img = thiefManager.lastThiefDetection.snapshot, let imageValue = Image(nsImage: img) {
                    Divider()
                    Text("Last Snapshot:")
                    imageValue
                        .resizable()
                        .scaledToFit().frame(width: 300, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text(dateText)
                }
            }
            Divider()
            Button("Quit") {
                exit(0)
            }
            
        }
        .padding(16.0)
        .frame(width: 332.0)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
