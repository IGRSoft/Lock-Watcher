//
//  MainView.swift
//
//  Created on 04.07.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that represents the main content of the application.
struct MainView: View {
    /// An observed view model that provides the necessary data and functionality for this view.
    @StateObject private var viewModel: MainViewModel

    /// Initializes a new `MainView` with a provided view model.
    /// - Parameter viewModel: The view model for this view.
    init(viewModel: MainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    /// The body content of the `MainView`.
    var body: some View {
        let _ = Self.logViewChanges()
        // If access is granted, show the main content of the view.
        if viewModel.isAccessGranted {
            VStack(alignment: .leading) {
                LastThiefDetectionView(viewModel: viewModel.lastThiefDetectionViewModel)

                InfoView(viewModel: InfoViewModel(thiefManager: viewModel.thiefManager, isInfoExtended: $viewModel.isInfoExtended))
            }
            .padding(viewModel.viewSettings.border) // Apply border padding from the view settings.
            .frame(width: viewModel.viewSettings.window.width)
            .accessibilityIdentifier(AccessibilityID.Main.container)
        } else { // If access isn't granted, execute the access granted block when the view appears.
            Text("")
                .onAppear {
                    viewModel.accessGrantedBlock?()
                }
        }
    }
}

/// Provides a preview of the `MainView` for design and layout purposes.
struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        // Uncomment below if you want to preview the view in different languages.
        // ForEach(["en", "ru", "uk"], id: \.self) { id in
        MainView(viewModel: MainViewModel.preview)
        // .environment(\.locale, .init(identifier: id))
        // }
    }
}
