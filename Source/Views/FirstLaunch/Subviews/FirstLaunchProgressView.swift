//
//  FirstLaunchProgressView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that presents an animated progress indicator for the first launch experience.
struct FirstLaunchProgressView: View {
    
    /// The view model that supplies data and behavior to the view.
    private var viewModel: FirstLaunchProgressViewModel
    
    /// Initializes a new progress view with the provided view model.
    ///
    /// - Parameter viewModel: An instance of `FirstLaunchProgressViewModel` that provides data and behavior to the view.
    init(viewModel: FirstLaunchProgressViewModel) {
        self.viewModel = viewModel
    }
    
    /// The body property that returns the content of the view.
    var body: some View {
        // A label that displays a system image based on the view model's position.
        Label("", systemImage: viewModel.position.rawValue)
        // Start the animation when the view appears on the screen.
            .onAppear(perform: viewModel.startAnimation)
        // Adjust the font size based on the view model's frame size.
            .font(.system(size: viewModel.frameSize.height * 0.75))
        // Define the frame dimensions based on the view model's frame size.
            .frame(width: viewModel.frameSize.width, height: viewModel.frameSize.height, alignment: .center)
    }
}

/// A preview provider that assists developers in designing and testing `FirstLaunchProgressView` within Xcode's canvas without running the full app.
struct FirstLaunchProgressViews_Previews: PreviewProvider {
    
    /// A computed property that returns a preview instance of `FirstLaunchProgressView`.
    static var previews: some View {
        FirstLaunchProgressView(viewModel: FirstLaunchProgressViewModel.preview)
    }
}
