//
//  ExtendedDivider.swift
//
//  Created on 19.05.2022.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import SwiftUI

/// View modifier for creating an extended divider with an associated title.
struct ExtendedDividerModifier: ViewModifier {
    var isExtended: Binding<Bool>

    var titleKey: String = "" // Key for localizing the title text.
    var font: Font = .headline // Font used for the title.
    var lineWidth: CGFloat = DesignSystem.Layout.borderWidth // Width of the divider line.
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
    func extended(_ isExtended: Binding<Bool>, titleKey: String = "", font: Font = .headline, lineWidth: CGFloat = DesignSystem.Layout.borderWidth, lineColor: Color = DesignSystem.Colors.divider) -> some View {
        modifier(ExtendedDividerModifier(isExtended: isExtended, titleKey: titleKey, font: font, lineWidth: lineWidth, lineColor: lineColor))
    }
}

/// Represents a visual divider that can be extended with an associated title.
struct ExtendedDivider: View {
    /// Represents a single line (either horizontal or vertical) used within the extended divider.
    private struct ExtendedDividerLine: View {
        let width: CGFloat
        let color: Color
        var direction: Axis.Set = .horizontal

        var body: some View {
            Rectangle()
                .fill(color)
                .applyIf(direction == .vertical) {
                    $0.frame(width: width)
                        .ignoresSafeArea(.all, edges: .vertical)
                } else: {
                    $0.frame(height: width)
                        .ignoresSafeArea(.all, edges: .horizontal)
                }
        }
    }

    var isExtended: Binding<Bool>

    @State var titleKey = "" // Key for localizing the title text.
    @State var font: Font = .headline // Font used for the title.
    @State var lineWidth: CGFloat = DesignSystem.Layout.borderWidth // Width of the divider line.
    @State var lineColor = DesignSystem.Colors.divider // Color of the divider line.

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
                        .foregroundColor(isExtended.wrappedValue ? DesignSystem.Colors.extendedMenu : DesignSystem.Colors.defaultMenu)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .accessibilityIdentifier(AccessibilityID.ExtendedDivider.toggleButton)
            .accessibilityLabel(
                isExtended.wrappedValue
                    ? AccessibilityLabel.ExtendedDivider.collapse(titleKey.isEmpty ? "" : NSLocalizedString(titleKey, comment: ""))
                    : AccessibilityLabel.ExtendedDivider.expand(titleKey.isEmpty ? "" : NSLocalizedString(titleKey, comment: ""))
            )
            ExtendedDividerLine(width: lineWidth, color: lineColor)
        }
        .onTapGesture {
            isExtended.wrappedValue.toggle()
        }
        .padding(DesignSystem.Spacing.xs)
        .accessibilityIdentifier(AccessibilityID.ExtendedDivider.container)
        .accessibilityElement(children: .combine)
    }
}

#Preview("Extended") {
    ExtendedDivider(isExtended: .constant(true))
}

#Preview("Collapsed") {
    ExtendedDivider(isExtended: .constant(false))
}
