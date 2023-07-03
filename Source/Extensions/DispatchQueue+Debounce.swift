//
//  DispatchQueue+IGRExtension.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 08.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    /// debounce action in time interval:
    /// .seconds(Int)
    /// .milliseconds(Int)
    /// .microseconds(Int)
    /// .nanoseconds(Int)
    ///
    func debounce(interval: DispatchTimeInterval, action: @escaping (() -> Void)) -> () -> Void {
        {
            let dispatchIn = DispatchTime.now() + interval
            
            self.asyncAfter(deadline: dispatchIn) {
                if DispatchTime.now() >= dispatchIn {
                    action()
                }
            }
        }
    }
}


