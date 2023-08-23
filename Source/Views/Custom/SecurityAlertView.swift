//
//  SecurityAlertView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 02.02.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI
import AppKit

/// Represents a view for obtaining secure input, typically a password.
///
/// The user has the option to either confirm or cancel the action.
/// When either of the buttons is pressed, the alert view is dismissed.
struct SecurityAlertView: View {
    @Binding var password: String        // Holds the value of the password entered by the user.
    @Binding var isPresented: Bool       // Determines if the alert view is presented or not.
    
    var body: some View {
        
        VStack {
            // Displaying the prompt for the password.
            Text("EnterPassword")
                .font(.headline)
                .padding()
            
            // Secure field for password input.
            SecureField("", text: $password)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Divider()
            
            HStack {
                Spacer()
                
                // OK Button: This will confirm the password input.
                Button(action: {
                    isPresented = false  // Dismiss the alert view.
                }) {
                    Text("ButtonOk")
                }
                
                Spacer()
                
                Divider()
                
                Spacer()
                
                // Cancel Button: This will dismiss the alert without taking any action.
                Button(action: {
                    isPresented = false  // Dismiss the alert view.
                }) {
                    Text("ButtonCancel")
                }
                
                Spacer()
            }
            .padding(.zero)
            
        }
        .background(Color(white: 0.9)) // Setting a light gray background.
    }
}

/// Provides a preview of the `SecurityAlertView`.
struct SecurityAlertView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityAlertView(password: .constant("1234"), isPresented: .constant(true))
    }
}
