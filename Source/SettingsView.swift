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
            Divider()
            Button("Quit") {
                exit(0)
            }
        }
        .padding(16.0)
        .frame(width: 300.0)
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
