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
    var body: some View {
        VStack(spacing: 16.0) {
            LaunchAtLogin.Toggle(LocalizedStringKey("LaunchAtLogin"))
        }
    }
}

struct ProtectionView: View {
    @Binding var isProtectioEnable : Bool
    @State var password : String = ""
    
    var body: some View {
        HStack(spacing: 8.0, content: {
            Toggle(isOn: $isProtectioEnable) {
                Text("ProtectAccess")
            }
            SecureField("ProtectPassword", text: $password)
                .textFieldStyle(.roundedBorder)
                .disabled(isProtectioEnable == false)
            Button("ButtonSet") {
                SecurityUtil.save(password: password)
                password = ""
            }
            .disabled(isProtectioEnable == false || password.isEmpty)
        })
    }
}
