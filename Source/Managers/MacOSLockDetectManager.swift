//
//  MacOSLockDetectManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 17.12.2024.
//  Copyright © 2024 IGR Soft. All rights reserved.
//

import Foundation

import Foundation
import CoreGraphics
import Combine

protocol MacOSLockDetectorProtocol {
    var isLockedPublisher: PassthroughSubject<Bool, Never> { get }
}

final class MacOSLockDetector: MacOSLockDetectorProtocol, @unchecked Sendable {
    
    let isLockedPublisher = PassthroughSubject<Bool, Never>()
    
    private var timer: Timer?
    
    init() {
        startTimer()
    }
    
    deinit {
        stopTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: checkLock)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @Sendable
    private func checkLock(_ timer: Timer) {
        isLockedPublisher.send(isSystemLocked())
    }
    
    /// Checks whether the macOS session is locked.
    /// - Returns: `true` if the session is locked, otherwise `false`.
    private func isSystemLocked() -> Bool {
        guard let sessionInfo = CGSessionCopyCurrentDictionary() as? [String: Any] else {
            return false
        }
        
        let isLocked = sessionInfo["CGSSessionScreenIsLocked"] as? Bool ?? false
        
        return isLocked
    }
}
