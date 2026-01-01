//
//  DetectSnapshotViews.swift
//
//  Created on 23.08.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view component that provides a toggle for the user to enable or disable snapshot functionality upon system wake up.
struct UseSnapshotOnWakeUpView: View {
    /// A binding to a boolean value that indicates whether the snapshot on wake up feature is enabled or disabled.
    @Binding var isUseSnapshotOnWakeUp: Bool

    var body: some View {
        Toggle(isOn: $isUseSnapshotOnWakeUp) {
            Text("SnapshotOnWakeUp")
        }
        .accessibilityIdentifier(AccessibilityID.Settings.wakeUpToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.snapshotOnWakeUp)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}

/// A view component that provides a toggle for the user to enable or disable snapshot functionality upon system login.
struct UseSnapshotOnLoginView: View {
    /// A binding to a boolean value that indicates whether the snapshot on login feature is enabled or disabled.
    @Binding var isUseSnapshotOnLogin: Bool

    var body: some View {
        Toggle(isOn: $isUseSnapshotOnLogin) {
            Text("SnapshotOnLogin")
        }
        .accessibilityIdentifier(AccessibilityID.Settings.loginToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.snapshotOnLogin)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}

/// A view component that provides a toggle for the user to enable or disable snapshot functionality when the wrong password is entered.
struct UseSnapshotOnWrongPasswordView: View {
    /// A binding to a boolean value that indicates whether the snapshot on wrong password feature is enabled or disabled.
    @Binding var isUseSnapshotOnWrongPassword: Bool

    var body: some View {
        Toggle(isOn: $isUseSnapshotOnWrongPassword) {
            Text("SnapshotOnWrongPassword")
        }
        .accessibilityIdentifier(AccessibilityID.Settings.wrongPasswordToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.snapshotOnWrongPassword)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}

/// A view component that provides a toggle for the user to enable or disable snapshot functionality when the system switches to battery power.
struct UseSnapshotOnSwitchToBatteryPowerView: View {
    /// A binding to a boolean value that indicates whether the snapshot on switch to battery power feature is enabled or disabled.
    @Binding var isUseSnapshotOnSwitchToBatteryPower: Bool

    var body: some View {
        Toggle(isOn: $isUseSnapshotOnSwitchToBatteryPower) {
            Text("SnapshotOnSwitchToBatteryPower")
        }
        .accessibilityIdentifier(AccessibilityID.Settings.batteryToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.snapshotOnBattery)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}

/// A view component that provides a toggle for the user to enable or disable snapshot functionality when a USB is mounted.
struct UseSnapshotOnUSBMountView: View {
    /// A binding to a boolean value that indicates whether the snapshot on USB mount feature is enabled or disabled.
    @Binding var isUseSnapshotOnUSBMount: Bool

    var body: some View {
        Toggle(isOn: $isUseSnapshotOnUSBMount) {
            Text("SnapshotOnUSBMount")
        }
        .accessibilityIdentifier(AccessibilityID.Settings.usbToggle)
        .accessibilityLabel(AccessibilityLabel.Settings.snapshotOnUSB)
        .accessibilityHint(AccessibilityHint.Settings.toggleHint)
    }
}
