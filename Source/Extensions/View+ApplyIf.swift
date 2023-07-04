//
//  View+ApplyIf.swift
//  IGR Software
//
//  Created by Vitalii P on 30.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

extension View {
    
    /// Display first or second view depends of condition
    /// - Parameters:
    ///   - condition: boo condition
    ///   - apply: first view
    ///   - else: second view
    /// - Returns: some view
    /// 
    @ViewBuilder func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T, else: (Self) -> T) -> some View {
        if condition() {
            apply(self)
        } else {
            `else`(self)
        }
    }
}
