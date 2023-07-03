//
//  BaseView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 02.02.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI
import LaunchAtLogin

struct LaunchAtLoginView: View {
    init() {
        LaunchAtLogin.migrateIfNeeded()
    }
    
    var body: some View {
        VStack(spacing: 16.0) {
            LaunchAtLogin.Toggle(LocalizedStringKey("LaunchAtLogin"))
        }
    }
}

struct ProtectionView: View {
    @Binding var isProtectionEnable : Bool
    @State var password : String = ""
    
    var body: some View {
        HStack(spacing: 8.0, content: {
            Toggle(isOn: $isProtectionEnable) {
                Text("ProtectAccess")
            }
            SecureField("ProtectPassword", text: $password)
                .textFieldStyle(.roundedBorder)
                .disabled(isProtectionEnable == false)
            Button("ButtonSet") {
                SecurityUtil.save(password: password)
                password = ""
            }
            .disabled(isProtectionEnable == false || password.isEmpty)
        })
    }
}
