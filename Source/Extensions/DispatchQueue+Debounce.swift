//
//  DispatchQueue+IGRExtension.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 08.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    /// Debounces a given action by waiting for a specified time interval before executing.
    /// If called multiple times within the interval, only the last call will trigger the action.
    ///
    /// - Parameters:
    ///   - interval: The duration to wait before executing the action. Can be in seconds, milliseconds, microseconds, or nanoseconds.
    ///   - action: The action/closure to execute after the debounce interval.
    ///
    /// - Returns: A function that can be invoked to trigger the debounce behavior.
    func debounce(interval: DispatchTimeInterval, action: @escaping (() -> Void)) -> () -> Void {
        {
            let dispatchIn = DispatchTime.now() + interval
            
            self.asyncAfter(deadline: dispatchIn) {
                // Ensure that the current time is greater than or equal to the specified interval.
                // This check ensures that the action is only executed once after the interval.
                if DispatchTime.now() >= dispatchIn {
                    action()
                }
            }
        }
    }
}


