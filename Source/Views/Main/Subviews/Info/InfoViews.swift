//
//  InfoViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import SwiftUI

/// A SwiftUI view that displays informational controls and links for the application.
struct InfoView: View {
    /// The view model which provides data and functions for the `InfoView`.
    @ObservedObject private var viewModel: InfoViewModel
    
    /// Initializes a new `InfoView` with the given view model.
    ///
    /// - Parameter viewModel: The view model associated with this view.
    init(viewModel: InfoViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
#if DEBUG
        // Print changes in the view for debug purposes.
        let _ = Self._printChanges()
#endif
        // Main content for the `InfoView`.
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                // Display debug trigger if `isImageCaptureDebug` is enabled in settings.
                if AppSettings.isImageCaptureDebug {
                    Button(action: viewModel.debugTrigger, label: viewModel.debugTitle)
                }
                
                // Button to open the application's settings.
                Button(action: viewModel.openSettings, label: viewModel.openSettingsTitle)
                
                // Button to quit the application.
                Button(action: viewModel.quitApp, label: viewModel.quitAppTitle)
                
                // Link to the IGR Software website.
                Link(viewModel.linkText, destination: viewModel.linkUrl)
                    .frame(maxWidth: .infinity)
            }
            // Extends the view's content based on the `isInfoExtended` property from the view model.
            .extended($viewModel.isInfoExtended, font: .title)
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with `isInfoExtended` set to false.
        InfoView(viewModel: InfoViewModel(thiefManager: ThiefManagerPreview(), isInfoExtended: .constant(false)))
        
        // Preview with `isInfoExtended` set to true.
        InfoView(viewModel: InfoViewModel(thiefManager: ThiefManagerPreview(), isInfoExtended: .constant(true)))
    }
}
