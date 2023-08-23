//
//  ProtectionView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 02.02.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view component that provides a user interface for enabling protection access to the application.
/// The user can toggle the protection on or off and set a password to protect the access.
struct ProtectionView: View {
    
    /// A binding that determines if protection is enabled or not.
    @Binding var isProtectionEnable : Bool
    
    /// A state to manage the value of the password entered by the user.
    @State var password : String = ""
    
    /// The body of the view, containing a toggle to enable/disable protection, a secure field for password input, and a button to set the password.
    var body: some View {
        HStack(spacing: ViewConstants.spacing, content: {
            // A toggle that allows the user to enable or disable protection.
            Toggle(isOn: $isProtectionEnable) {
                Text("ProtectAccess")
            }
            // A secure field that allows the user to input a password.
            SecureField("ProtectPassword", text: $password)
                .textFieldStyle(.roundedBorder)
            // Disable password input if protection is turned off.
                .disabled(isProtectionEnable == false)
            
            // A button that allows the user to set the entered password.
            Button("ButtonSet") {
                SecurityUtil.save(password: password)
                password = "" // Clear the password field after saving.
            }
            // Disable the set button if protection is turned off or password field is empty.
            .disabled(isProtectionEnable == false || password.isEmpty)
        })
    }
}

/// A preview provider for the `ProtectionView`, useful for visualizing the component in design tools and SwiftUI previews.
struct ProtectionView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with protection enabled.
        ProtectionView(isProtectionEnable: .constant(true))
        
        // Preview with protection disabled.
        ProtectionView(isProtectionEnable: .constant(false))
    }
}
