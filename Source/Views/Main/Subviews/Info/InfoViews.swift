//
//  InfoViews.swift
//
//  Created on 04.07.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
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
        let _ = Self.logViewChanges()
        // Main content for the `InfoView`.
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                // Display debug trigger if `isImageCaptureDebug` is enabled in settings.
                if AppSettings.isImageCaptureDebug {
                    Button(action: viewModel.debugTrigger, label: viewModel.debugTitle)
                        .accessibilityIdentifier(AccessibilityID.Info.debugTriggerButton)
                }

                // Button to open the application's settings.
                if #available(macOS 14.0, *) {
                    SettingsLink(label: viewModel.openSettingsTitle)
                        .accessibilityIdentifier(AccessibilityID.Info.openSettingsButton)
                        .accessibilityLabel(AccessibilityLabel.Info.openSettings)
                } else {
                    Button(action: viewModel.openSettings, label: viewModel.openSettingsTitle)
                        .accessibilityIdentifier(AccessibilityID.Info.openSettingsButton)
                        .accessibilityLabel(AccessibilityLabel.Info.openSettings)
                }

                // Button to quit the application.
                Button(action: viewModel.quitApp, label: viewModel.quitAppTitle)
                    .accessibilityIdentifier(AccessibilityID.Info.quitButton)
                    .accessibilityLabel(AccessibilityLabel.Info.quitApp)

                // Link to the IGR Software website.
                Link(viewModel.linkText, destination: viewModel.linkUrl)
                    .frame(maxWidth: .infinity)
                    .accessibilityIdentifier(AccessibilityID.Info.websiteLink)
                    .accessibilityLabel(AccessibilityLabel.Info.visitWebsite)
            }
            // Extends the view's content based on the `isInfoExtended` property from the view model.
            .extended($viewModel.isInfoExtended, font: DesignSystem.Typography.title)
        }
        .accessibilityIdentifier(AccessibilityID.Info.container)
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
