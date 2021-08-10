//
//  NSImage+IGRExtension.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 10.08.2021.
//

import AppKit
import CoreGraphics

extension NSImage {
    func imageWithText(text: String) -> NSImage? {
        let imageSize = self.size
        let font = NSFont.boldSystemFont(ofSize: 18)
        let imageRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        let textRect = CGRect(x: 5, y: 5, width: imageSize.width - 5, height: imageSize.height - 5)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: NSColor.red,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        let image: NSImage = NSImage(size: imageSize)
        guard let rep: NSBitmapImageRep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                                     pixelsWide: Int(imageSize.width),
                                                     pixelsHigh: Int(imageSize.height),
                                                     bitsPerSample: 8,
                                                     samplesPerPixel: 4,
                                                     hasAlpha: true,
                                                     isPlanar: false,
                                                     colorSpaceName: .calibratedRGB,
                                                     bytesPerRow: 0,
                                                     bitsPerPixel: 0) else {
            assert(false, "can't get BitmapImage")
            return self
        }
        
        image.addRepresentation(rep)
        image.lockFocus()
        self.draw(in: imageRect)
        text.draw(in: textRect, withAttributes: textFontAttributes)
        image.unlockFocus()
        return image
    }
}
