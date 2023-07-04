//
//  SecurityAlertView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 02.02.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI
import AppKit

struct SecurityAlertView: View {
    @Binding var password: String
    @Binding var isPresented: Bool
    
    var body: some View {
        
        VStack {
            Text("EnterPassword").font(.headline).padding()
            
            SecureField("", text: $password).textFieldStyle(.roundedBorder).padding()
            Divider()
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Text("ButtonOk")
                }
                Spacer()
                
                Divider()
                
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Text("ButtonCancel")
                }
                Spacer()
            }.padding(.zero)
        }.background(Color(white: 0.9))
    }
}

struct SecurityAlertView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityAlertView(password: .constant("1234"), isPresented: .constant(true))
    }
}
