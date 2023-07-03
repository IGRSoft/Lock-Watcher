//
//  NSImage+Text.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 10.08.2021.
//

import AppKit
import CoreGraphics

extension NSImage {
    
    /// add text to left top corner of image
    ///
    func imageWithText(text: String, fontSize: CGFloat = 12, color: NSColor = .red.withAlphaComponent(0.8)) -> NSImage? {
        let imageSize = self.size
        let imageRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        let scaleFactor = NSScreen.main?.backingScaleFactor ?? 1
        let font = NSFont.boldSystemFont(ofSize: fontSize * scaleFactor)
        let textRect = CGRect(x: 5, y: 5, width: imageRect.size.width - 5, height: imageRect.size.height - 5)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes: [NSAttributedString.Key : Any] = [.font: font, .foregroundColor: color, .paragraphStyle: textStyle]
        
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return self
        }
        
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        bitmapRep.size = imageRect.size
        
        let image: NSImage = NSImage(size: imageRect.size)
        image.addRepresentation(bitmapRep)
        
        image.lockFocus()
        self.draw(in: imageRect)
        text.draw(in: textRect, withAttributes: textFontAttributes)
        image.unlockFocus()
        
        return image
    }
}
