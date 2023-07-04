//
//  ProtectionView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 02.02.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

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

struct ProtectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProtectionView(isProtectionEnable: .constant(true))
        
        ProtectionView(isProtectionEnable: .constant(false))
    }
}
