//
//  ExtendedDevider.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 19.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

struct ExtendedDividerModifier: ViewModifier {
    
    var isExtended: Binding<Bool>
    
    var titleKey: String = ""
    var font: Font = .headline
    var lineWidth: CGFloat = 1
    var lineColor: Color = Color("divider")
    
    public func body(content: Content) -> some View {
        ExtendedDivider(isExtended: isExtended, titleKey: titleKey, font: font, lineWidth: lineWidth, lineColor: lineColor)
        if isExtended.wrappedValue {
            content
        }
    }
}

extension View {
    func extended(_ isExtended: Binding<Bool>, titleKey: String = "", font: Font = .headline, lineWidth: CGFloat = 1, lineColor: Color = Color("divider")) -> some View {
        modifier(ExtendedDividerModifier(isExtended: isExtended, titleKey: titleKey,font: font, lineWidth: lineWidth, lineColor: lineColor))
    }
}

struct ExtendedDivider: View {
    var isExtended: Binding<Bool>
    
    @State var titleKey = ""
    @State var font: Font = .headline
    @State var lineWidth: CGFloat = 1
    @State var lineColor = Color("divider")
    
    var body: some View {
        HStack {
            ExtendedDividerLine(width: lineWidth, color: lineColor)
            Button(action: {
                isExtended.wrappedValue.toggle()
            }) {
                HStack {
                    if !titleKey.isEmpty {
                        Text(NSLocalizedString(titleKey, comment: ""))
                            .font(font)
                    }
                    Image(systemName: isExtended.wrappedValue ? "chevron.compact.down" : "chevron.compact.up")
                        .font(font)
                        .foregroundColor(isExtended.wrappedValue ? Color("extendedMenu") : Color("defaultMenu"))
                }
            }.buttonStyle(BorderlessButtonStyle())
            ExtendedDividerLine(width: lineWidth, color: lineColor)
        }
        .onTapGesture {
            isExtended.wrappedValue.toggle()
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
