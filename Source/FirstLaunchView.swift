//
//  FirstLaunchView.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchView: View {
    
    enum StateMode: Int {
        case idle
        case inProgress
        case success
        case fault
        
        static let allValues = [idle, inProgress, success, fault]
    }
    
    private struct Size {
        static let width: CGFloat = 300
        static let height: CGFloat = 200
        
        static let minPadding: CGFloat = 8
        static let maxPadding: CGFloat = 16 //double of min
    }
    
    @ObservedObject var settings: AppSettings
    @ObservedObject var thiefManager: ThiefManager
    
    @Binding var isHidden: Bool
    @Binding var isAccessGranted: Bool
    
    @State private var state: StateMode = .idle
    @State private var successConuntDown = 1
    
    @State private var windowSize = CGSize(width: Size.width, height: Size.height)
    @State private var safeArea = CGSize(width: Size.width - Size.minPadding, height: Size.height - Size.minPadding)
    
    @State var isNeedRestart: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: Size.maxPadding) {
            switch state {
            case .idle:
                FirstLaunchOptionsViews(settings: settings)
                Button("TakeSnapshotAndStart") {
                    state = .inProgress
                    
                    thiefManager.detectedTriger() { success in
                        state = success ? .success : .fault
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                            if successConuntDown == 0 {
                                timer.invalidate()
                                isHidden = true
                                isAccessGranted = true
                                NSApplication.shared.keyWindow?.close()
                            }
                            successConuntDown -= 1
                        }
                    }
                }
            case .inProgress:
                FirstLaunchProgressViews(frameSize: $safeArea)
            case .success:
                FirstLaunchSuccessViews(successConuntDown: $successConuntDown, frameSize: $safeArea)
            case .fault:
                if !isNeedRestart {
                    FirstLaunchFaultViews(isHidden: $isNeedRestart, frameSize: $safeArea)
                } else {
                    Text("")
                        .onAppear() {
                            state = .idle
                            isNeedRestart = false
                        }
                }
            }
        }
        .padding(EdgeInsets(top: Size.maxPadding, leading: Size.maxPadding, bottom: Size.maxPadding, trailing: Size.maxPadding))
        .frame(width: windowSize.width, height: windowSize.height, alignment: .center)
    }
}
