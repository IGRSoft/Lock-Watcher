//
//  FirstLaunchView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchView<AppSettingsModel, ThiefManagerModel>: View where AppSettingsModel: AppSettingsProtocol, ThiefManagerModel: ThiefManagerProtocol {
    
    enum StateMode: Int, CaseIterable {
        case idle
        case inProgress
        case success
        case fault
        
        static var allCases: [StateMode] {
            [.idle, .inProgress, .success, .fault]
        }
    }
    
    private enum Size: CGFloat {
        typealias RawValue = CGFloat
        
        case width = 320
        case height = 220
        
        case minPadding = 8
        case maxPadding = 16 //double of min
    }
    
    @ObservedObject var settings: AppSettingsModel
    @ObservedObject var thiefManager: ThiefManagerModel
    
    @Binding var isHidden: Bool
    @State var closeClosure: AppEmptyClosure
    
    @State private var state: StateMode = .idle
    @State private var successCountDown = AppSettings.firstLaunchSuccessConunt
    
    @State private var windowSize = CGSize(width: Size.width.rawValue, height: Size.height.rawValue)
    @State private var safeArea = CGSize(width: Size.width.rawValue - Size.minPadding.rawValue, height: Size.height.rawValue - Size.minPadding.rawValue)
    
    @State var isNeedRestart: Bool = false
    
    @State private var showingAlert = false
    
    @State private var timer: Timer?
    
    var body: some View {
        VStack(alignment: .center, spacing: Size.maxPadding.rawValue) {
            switch state {
            case .idle:
                FirstLaunchOptionsViews(settings: settings)
                Button("TakeSnapshotAndStart") {
                    state = .inProgress
                    
                    PermissionsUtils.updateCameraPermissions { isGranted in
                        if isGranted {
                            thiefManager.detectedTrigger() { success in
                                state = success ? .success : .fault
                                if success {
                                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                                        if successCountDown == 0 {
                                            timer.invalidate()
                                            isHidden = true
                                            NSApp.windows.first?.close()
                                            closeClosure()
                                        } else {
                                            successCountDown -= 1
                                        }
                                    }
                                } else {
                                    showingAlert = true
                                }
                            }
                        } else {
                            state = .fault
                            showingAlert = true
                        }
                    }
                }
                .alert("OpenSettings", isPresented: $showingAlert) {
                    Button("ButtonSettings") {
                        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera")!)
                    }
                    Button("ButtonCancel", role: .cancel) { }
                }
            case .inProgress:
                FirstLaunchProgressViews(frameSize: $safeArea)
            case .success:
                FirstLaunchSuccessViews(successCountDown: $successCountDown, frameSize: $safeArea)
            case .fault:
                if !isNeedRestart {
                    FirstLaunchFaultViews(isHidden: $isNeedRestart, frameSize: $safeArea)
                } else {
                    Text("")
                        .onAppear() {
                            state = .idle
                            isNeedRestart.toggle()
                        }
                }
            }
        }
        .padding(EdgeInsets(top: Size.maxPadding.rawValue, leading: Size.maxPadding.rawValue, bottom: Size.maxPadding.rawValue, trailing: Size.maxPadding.rawValue))
        .frame(width: windowSize.width, height: windowSize.height, alignment: .center)
        .onDisappear() {
            timer?.invalidate()
        }
    }
}
