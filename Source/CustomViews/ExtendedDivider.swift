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
    
    @State var title = ""
    @State var font: Font = .headline
    @State var lineWidth: CGFloat = 1
    @State var lineColor = Color("divider")
    
    var body: some View {
        HStack {
            ExtendedDividerLine(width: lineWidth, color: lineColor)
            Button(action: {
                isExtended.toggle()
            }) {
                HStack {
                    if title.count > 0 {
                        Text(NSLocalizedString(title, comment: ""))
                            .font(font)
                    }
                    Image(systemName: isExtended ? "chevron.compact.down" : "chevron.compact.up")
                        .font(font)
                        .foregroundColor(isExtended ? Color("extendedMenu") : Color("defaultMenu"))
                }
            }.buttonStyle(BorderlessButtonStyle())
            ExtendedDividerLine(width: lineWidth, color: lineColor)
        }
        .onTapGesture {
            isExtended.toggle()
        }
        .padding(4)
    }
}

struct ExtendedDividerLine: View {
    @State var width: CGFloat = 1
    @State var color: Color = .gray
    
    var direction: Axis.Set = .horizontal
    
    var body: some View {
        Rectangle()
            .fill(color)
            .applyIf(direction == .vertical) {
                $0.frame(width: width)
                    .edgesIgnoringSafeArea(.vertical)
            } else: {
                $0.frame(height: width)
                    .edgesIgnoringSafeArea(.horizontal)
            }
    }
}
