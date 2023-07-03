//
//  UseSnapshotViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import SwiftUI

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
