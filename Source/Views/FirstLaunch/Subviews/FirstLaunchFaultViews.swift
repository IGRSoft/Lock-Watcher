//
//  FirstLaunchFaultViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 15.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchFaultViews: View {
    @Binding var isHidden: Bool
    
    @State var frameSize: CGSize
    
    var body: some View {
        VStack {
            Label("SetupFault", systemImage: "exclamationmark.circle")
                .font(.system(size: frameSize.height * 0.25))
                .padding(.horizontal)
                .foregroundColor(Color("error"))
            Text("SetupFaultMessage")
                .font(.headline)
            Button("SetupOpenSettings") {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera")!)
                isHidden = true
            }
        }
    }
}

struct FirstLaunchFaultViews_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchFaultViews(isHidden: .constant(false), frameSize: CGSize(width: 400, height: 300))
    }
}
