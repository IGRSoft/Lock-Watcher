//
//  FirstLaunchProgressViewModel.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A view model responsible for managing the progression of animation states during the first launch of the app.
final class FirstLaunchProgressViewModel: ObservableObject, @unchecked Sendable {
    /// Enumeration of the positions for the animation.
    ///
    /// Each case represents a different stage in the animation and is associated with a sun icon from SF Symbols.
    enum Positions: String {
        case state0 = "sun.min"
        case state1 = "sun.min.fill"
        case state2 = "sun.max"
        case state3 = "sun.max.fill"
        
        /// An array of all available positions for the animation.
        static let allValues = [state0, state1, state2, state3]
    }
    
    /// Private integer representing the index of the current animation position.
    @Published private var pos: Int = .zero
    
    /// The current animation position from the `Positions` enum.
    @Published var position: Positions = .allValues[0]
    
    /// The frame size for the associated view, used to layout subviews appropriately.
    @State var frameSize: CGSize
    
    /// Initializes a new instance of the view model with the given frame size.
    /// - Parameter frameSize: The size of the frame in which the animations are displayed.
    init(frameSize: CGSize) {
        self.frameSize = frameSize
    }
    
    /// Starts the animation sequence, transitioning through each position in the `Positions` enum.
    ///
    /// The animation will loop indefinitely, cycling through the positions at a quarter-second interval.
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: animate)
    }
    
    @Sendable
    private func animate(_ timaer: Timer) {
        self.pos += 1
        var pos = pos
        if pos == Positions.allValues.count {
            pos = 0
            self.pos = pos
        }
        position = .allValues[pos]
    }
}

extension FirstLaunchProgressViewModel {
    /// A preview instance of the view model with a default frame size.
    ///
    /// This is useful for design-time previewing in SwiftUI.
    static var preview: FirstLaunchProgressViewModel {
        .init(frameSize: CGSize(width: 300, height: 300))
    }
}
