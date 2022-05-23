//
//  DispatchQueue+IGRExtension.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 08.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation

typealias Debounce<T> = (_ : T) -> Void

extension DispatchQueue {
    func debounce(interval: Int, action: @escaping (() -> Void)) -> () -> Void {
        var lastFireTime = DispatchTime.now()
        let dispatchDelay = DispatchTimeInterval.milliseconds(interval)
        
        return {
            lastFireTime = DispatchTime.now()
            let dispatchTime: DispatchTime = DispatchTime.now() + dispatchDelay
            
            self.asyncAfter(deadline: dispatchTime) {
                let when: DispatchTime = lastFireTime + dispatchDelay
                let now = DispatchTime.now()
                if now.rawValue >= when.rawValue {
                    action()
                }
            }
        }
    }
}


