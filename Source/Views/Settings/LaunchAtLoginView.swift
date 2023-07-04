//
//  LaunchAtLoginView.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import LaunchAtLogin

struct LaunchAtLoginView: View {
    init() {
        LaunchAtLogin.migrateIfNeeded()
    }
    
    var body: some View {
        LaunchAtLogin.Toggle(LocalizedStringKey("LaunchAtLogin"))
    }
}

struct LaunchAtLoginView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchAtLoginView()
    }
}
