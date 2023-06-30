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


