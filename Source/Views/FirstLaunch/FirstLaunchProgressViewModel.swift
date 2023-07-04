//
//  FirstLaunchProgressViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

class FirstLaunchProgressViewModel: ObservableObject {
    enum Positions: String {
        case state0 = "sun.min"
        case state1 = "sun.min.fill"
        case state2 = "sun.max"
        case state3 = "sun.max.fill"
        
        static let allValues = [state0, state1, state2, state3]
    }
    
    @Published private var pos: Int = .zero
    @Published var position: Positions = .allValues[0]
    
    @State var frameSize: CGSize
    
    init(frameSize: CGSize) {
        self.frameSize = frameSize
    }
    
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] timer in
            self?.pos += 1
            var pos = self?.pos ?? 0
            if pos == Positions.allValues.count {
                pos = 0
                self?.pos = pos
            }
            self?.position = .allValues[pos]
        }
    }
}

extension FirstLaunchProgressViewModel {
    static var preview = FirstLaunchProgressViewModel(frameSize: CGSize(width: 300, height: 300))
}
