//
//  SettingsView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 03.12.2020.
//

import SwiftUI

struct SettingsView: View {
    @State private var isSaveToFile: Bool = false
    
    private let thiefManager = ThiefManager()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32.0) {
            Button("START") {
                start()
            }
            .padding(8.0)
            Button("STOP") {
                stop()
            }
            .padding(8.0)
            Toggle(isOn: $isSaveToFile) {
                Text("bla")
            }
        }
        .padding(16.0)
        .frame(width: 500.0)
    }
    
    private func start() {
        thiefManager.startWatching()
    }
    
    private func stop() {
        thiefManager.stopWatching()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
