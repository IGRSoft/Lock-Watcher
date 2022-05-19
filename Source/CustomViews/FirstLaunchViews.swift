//
//  FirstLaunchViews.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 15.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchOptionsViews: View {
    @ObservedObject var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LaunchAtLoginView()
            UseSnapshotOnWakeUpView(isUseSnapshotOnWakeUp: $settings.isUseSnapshotOnWakeUp)
                .onChange(of: settings.isUseSnapshotOnWakeUp, perform: { _ in })
            UseSnapshotOnLoginView(isUseSnapshotOnLogin: $settings.isUseSnapshotOnLogin)
                .onChange(of: settings.isUseSnapshotOnLogin, perform: { _ in })
            AddLocationToSnapshotView(addLocationToSnapshot: $settings.addLocationToSnapshot)
                .onChange(of: settings.addLocationToSnapshot, perform: { _ in })
            ICloudSyncView(isICloudSyncEnable: $settings.isICloudSyncEnable)
            
            Divider()
        }
    }
}

struct FirstLaunchProgressViews: View {
    
    enum Positions: String {
        case state0 = "sun.min"
        case state1 = "sun.min.fill"
        case state2 = "sun.max"
        case state3 = "sun.max.fill"
        
        static let allValues = [state0, state1, state2, state3]
    }
    
    @State private var iPosition: Int = 0
    @State var position: Positions = Positions.allValues[0]
    
    @Binding var frameSize: CGSize
    
    var body: some View {
        Label("", systemImage: position.rawValue)
            .onAppear() {
                Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
                    iPosition += 1
                    if (iPosition) == Positions.allValues.count {
                        iPosition = 0
                    }
                    position = Positions.allValues[iPosition]
                }
            }
            .font(.system(size: frameSize.height * 0.75))
            .foregroundColor(.white)
            .frame(width: frameSize.width, height: frameSize.height, alignment: .center)
    }
}

struct FirstLaunchSuccessViews: View {
    @Binding var successConuntDown: Int
    
    @Binding var frameSize: CGSize
    
    var body: some View {
        Label("SetupSuccess", systemImage: "bolt.circle")
            .font(.system(size: frameSize.height * 0.2))
            .padding(.horizontal)
            .foregroundColor(.green)
        Text("Tips0")
            .font(.headline)
            .foregroundColor(.green)
        Image("tips0").aspectRatio(contentMode: .fit)
            .frame(width: frameSize.width, height: .infinity, alignment: .center)
        Text(String(format: NSLocalizedString("SuccessTimer %d", comment: ""), successConuntDown))
            .font(.body)
            .foregroundColor(.white)
    }
}

struct FirstLaunchFaultViews: View {
    @Binding var isHidden: Bool
    
    @Binding var frameSize: CGSize
    
    var body: some View {
        Label("SetupFault", systemImage: "exclamationmark.circle")
            .font(.system(size: frameSize.height * 0.25))
            .padding(.horizontal)
            .foregroundColor(.red)
        Text("SetupFaultMessage")
            .font(.headline)
            .foregroundColor(.white)
        Button("SetupOpenSettings") {
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera")!)
            isHidden = true
        }
    }
}
