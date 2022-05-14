//
//  FirstLaunchView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchView: View {
    private struct K {
        static let windowHeightDefault: CGFloat = 200
        static let windowHeightExpand: CGFloat = 310
    }
    
    @ObservedObject var settings: AppSettings
    @ObservedObject var thiefManager: ThiefManager
    @State var successInProgress = false
    @State var successConuntDown = 5
    
    @State var windowHeight: CGFloat = FirstLaunchView.K.windowHeightDefault
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: $settings.isUseSnapshotOnWakeUp)
                    .onChange(of: settings.isUseSnapshotOnWakeUp, perform: { _ in })
                UseSnapshotOnLoginView(isUseSnapshotOnLogin: $settings.isUseSnapshotOnLogin)
                    .onChange(of: settings.isUseSnapshotOnLogin, perform: { _ in })
                AddLocationToSnapshotView(addLocationToSnapshot: $settings.addLocationToSnapshot)
                    .onChange(of: settings.addLocationToSnapshot, perform: { _ in })
                ICloudSyncView(isICloudSyncEnable: $settings.isICloudSyncEnable)
                
                Divider()
            }
            if !successInProgress {
                Button("TakeSnapshotAndStart") {
                    thiefManager.detectedTriger() { success in
                        withAnimation(.easeInOut(duration: 0.1)) { windowHeight = success ? K.windowHeightExpand : K.windowHeightDefault }
                        successInProgress = success
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            if successConuntDown == 0 {
                                timer.invalidate()
                                NSApplication.shared.keyWindow?.close()
                            }
                            successConuntDown -= 1
                        }
                    }
                }
            } else {
                Label("Success", systemImage: "bolt.circle")
                    .font(.title3)
                    .padding(.horizontal)
                    .foregroundColor(.green)
                Text("Tips0")
                    .font(.headline)
                    .foregroundColor(.green)
                Image("tips0").aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 40, alignment: .center)
                Text(String(format: NSLocalizedString("SuccessTimer %d", comment: ""), successConuntDown))
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
        .padding(EdgeInsets(top: 16.0, leading: 8.0, bottom: 16.0, trailing: 8.0))
        .frame(width: 300, height: windowHeight, alignment: .topLeading)
    }
}
