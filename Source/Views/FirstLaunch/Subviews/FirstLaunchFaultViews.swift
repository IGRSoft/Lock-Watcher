//
//  FirstLaunchFaultViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 15.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that presents a fault message and action to guide the user when there's a setup fault on first launch.
struct FirstLaunchFaultViews: View {
    /// A binding that informs if this fault view should be hidden.
    @Binding var isHidden: Bool
    
    /// The frame size for adjusting visual elements within this view.
    @State var frameSize: CGSize
    
    /// The body property that returns the content of the view.
    var body: some View {
        VStack {
            // Label showing a fault message along with an associated system image.
            Label("SetupFault", systemImage: "exclamationmark.circle")
                .font(.system(size: frameSize.height * 0.25))
                .padding(.horizontal)
                .foregroundColor(Color("error"))
            
            // Additional text message providing more information about the fault.
            Text("SetupFaultMessage")
                .font(.headline)
            
            // Button that directs the user to open their system settings.
            Button("SetupOpenSettings") {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera")!)
                isHidden = true
            }
        }
    }
}

/// A preview provider that assists developers in designing and testing `FirstLaunchFaultViews` within Xcode's canvas
struct FirstLaunchFaultViews_Previews: PreviewProvider {
    static var previews: some View {
        FirstLaunchFaultViews(isHidden: .constant(false), frameSize: CGSize(width: 400, height: 300))
    }
}
