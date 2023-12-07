//
//  FirstLaunchSuccessView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that presents a success message and visuals to the user when the initial setup completes successfully.
struct FirstLaunchSuccessView: View {
    
    /// A binding to the count-down timer value that informs the user about the time left before proceeding.
    @Binding var successCountDown: Int
    
    /// The frame size for adjusting visual elements within this view.
    @State var frameSize: CGSize
    
    /// The body property that returns the content of the view.
    var body: some View {
        VStack {
            // Label showing a success message along with an associated system image.
            Label("SetupSuccess", systemImage: "bolt.circle")
                .font(.system(size: frameSize.height * 0.2))
                .padding(.horizontal)
                .foregroundColor(Color("success"))
            
            // Text that provides additional information or tips after the successful setup.
            Text("Tips0")
                .font(.headline)
                .foregroundColor(Color("success"))
            
            // Image providing a visual tip or guide for the user after the successful setup.
            Image("tips0").aspectRatio(contentMode: .fit)
                .frame(width: frameSize.width, alignment: .center)
            
            // Countdown timer text, showing the user how much time is left before moving on.
            Text(String(format: NSLocalizedString("SuccessTimer %d", comment: ""), successCountDown))
                .font(.body)
        }
    }
}

/// A preview provider that assists developers in designing and testing `FirstLaunchSuccessView` within Xcode's canvas without running the full app.
struct FirstLaunchSuccessView_Previews: PreviewProvider {
    
    /// A computed property that returns a preview instance of `FirstLaunchSuccessView`.
    static var previews: some View {
        FirstLaunchSuccessView(successCountDown: .constant(5), frameSize: CGSize(width: 400, height: 300))
    }
}
