//
//  ExtendedDevider.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 19.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T, else: (Self) -> T) -> some View {
        if condition() {
            apply(self)
        } else {
            `else`(self)
        }
    }
}

struct ExtendedDivider: View {
    @Binding var isExtended: Bool
    @State var title: String = ""
    
    var body: some View {
        ZStack {
            HStack {
                ExtendedDividerLine()
                Button(action: {
                    isExtended.toggle()
                }) {
                    HStack {
                        Text(title)
                        Image(systemName: isExtended ? "chevron.compact.down" : "chevron.compact.up")
                            .font(.system(size: 22))
                    }
                }.buttonStyle(BorderlessButtonStyle())
                ExtendedDividerLine()
            }
        }
    }
}

struct ExtendedDividerLine: View {
    var width: CGFloat = 2
    var direction: Axis.Set = .horizontal
    
    var body: some View {
        Rectangle()
            .fill(.gray)
            .applyIf(direction == .vertical) {
                $0.frame(width: width)
                    .edgesIgnoringSafeArea(.vertical)
            } else: {
                $0.frame(height: width)
                    .edgesIgnoringSafeArea(.horizontal)
            }
    }
}
