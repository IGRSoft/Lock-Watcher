//
//  FirstLaunchView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var settings: AppSettings
    @ObservedObject var thiefManager: ThiefManager
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: $settings.isUseSnapshotOnWakeUp)
                .onChange(of: settings.isUseSnapshotOnWakeUp, perform: { _ in })
            UseSnapshotOnLoginView(isUseSnapshotOnLogin: $settings.isUseSnapshotOnLogin)
                .onChange(of: settings.isUseSnapshotOnLogin, perform: { _ in })
            AddLocationToSnapshotView(addLocationToSnapshot: $settings.addLocationToSnapshot)
                .onChange(of: settings.addLocationToSnapshot, perform: { _ in })
            ICloudSyncView(isICloudSyncEnable: $settings.isICloudSyncEnable)
            
            Divider()
            
            Button("TakeSnapshot") {
                thiefManager.detectedTriger()
            }.frame(width: 275)
        }
        .padding(EdgeInsets(top: 16.0, leading: 8.0, bottom: 16.0, trailing: 8.0))
        .frame(width: 300, height: 200, alignment: .topLeading)
    }
}
