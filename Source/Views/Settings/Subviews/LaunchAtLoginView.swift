//
//  LaunchAtLoginView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import LaunchAtLogin
import SwiftUI

/// A view component that provides a toggle for the user to enable or disable launching the app at system login.
struct LaunchAtLoginView: View {
    /// Initializes the view and performs necessary migrations for the `LaunchAtLogin` library, if needed.
    init() {
        LaunchAtLogin.migrateIfNeeded()
    }
    
    /// The body of the view, containing a toggle that is controlled by the `LaunchAtLogin` library.
    var body: some View {
        LaunchAtLogin.Toggle(LocalizedStringKey("LaunchAtLogin"))
    }
}

/// A preview provider for the `LaunchAtLoginView`, useful for visualizing the component in design tools and SwiftUI previews.
struct LaunchAtLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAtLoginView()
    }
}
