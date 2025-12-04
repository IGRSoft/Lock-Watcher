//
//  ExtendedDivider.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 19.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import SwiftUI

/// View modifier for creating an extended divider with an associated title.
struct ExtendedDividerModifier: ViewModifier {
    var isExtended: Binding<Bool>
    
    var titleKey: String = ""       // Key for localizing the title text.
    var font: Font = .headline      // Font used for the title.
    var lineWidth: CGFloat = 1      // Width of the divider line.
    var lineColor: Color = .init("divider") // Color of the divider line.
    
    /// Modifies the provided content by adding an extended divider to it.
    func body(content: Content) -> some View {
        ExtendedDivider(isExtended: isExtended, titleKey: titleKey, font: font, lineWidth: lineWidth, lineColor: lineColor)
        if isExtended.wrappedValue {
            content
        }
    }
}

extension View {
    /// Attaches the extended divider modifier to the view.
    func extended(_ isExtended: Binding<Bool>, titleKey: String = "", font: Font = .headline, lineWidth: CGFloat = 1, lineColor: Color = Color("divider")) -> some View {
        modifier(ExtendedDividerModifier(isExtended: isExtended, titleKey: titleKey,font: font, lineWidth: lineWidth, lineColor: lineColor))
    }
}

/// Represents a visual divider that can be extended with an associated title.
struct ExtendedDivider: View {
    /// Represents a single line (either horizontal or vertical) used within the extended divider.
    private struct ExtendedDividerLine: View {
        @State var width: CGFloat = 1
        @State var color: Color = .gray
        
        var direction: Axis.Set = .horizontal // Direction of the line
        
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
    
    var isExtended: Binding<Bool>
    
    @State var titleKey = ""       // Key for localizing the title text.
    @State var font: Font = .headline      // Font used for the title.
    @State var lineWidth: CGFloat = 1      // Width of the divider line.
    @State var lineColor = Color("divider") // Color of the divider line.
    
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

/// Preview provider for visual representation of the `ExtendedDivider` view.
struct ExtendedDivider_Previews: PreviewProvider {
    static var previews: some View {
        ExtendedDivider(isExtended: .constant(true))
        
        ExtendedDivider(isExtended: .constant(false))
    }
}
