//
//  NSImage+Data.swift
//
//  Created on 30.06.2023.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    /// Represents the `NSImage` as JPEG data using the default high quality (75%).
    ///
    /// - Returns: Data representation of the image in JPEG format. If the conversion fails, it returns an empty Data instance.
    var jpegData: Data {
        jpegData(quality: SnapshotQuality.high.compressionFactor)
    }

    /// Converts the `NSImage` to JPEG data with the specified compression quality.
    ///
    /// - Parameter quality: A value between 0.0 (maximum compression) and 1.0 (lossless) controlling JPEG quality.
    /// - Returns: Data representation of the image in JPEG format. If the conversion fails, it returns an empty Data instance.
    func jpegData(quality: CGFloat) -> Data {
        guard let tiffData = tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiffData) else {
            return Data()
        }

        guard let data = bitmap.representation(using: .jpeg, properties: [.compressionFactor: quality]) else {
            return Data()
        }

        return data
    }

    /// Returns a new image scaled by the given factor.
    ///
    /// - Parameter scaleFactor: The factor to scale by (e.g. 0.5 for half size). Values >= 1.0 return self unchanged.
    /// - Returns: A resized `NSImage`, or `self` if no scaling is needed.
    func resized(by scaleFactor: CGFloat) -> NSImage {
        guard scaleFactor < 1.0, scaleFactor > 0 else { return self }

        let currentSize = size
        let newWidth = floor(currentSize.width * scaleFactor)
        let newHeight = floor(currentSize.height * scaleFactor)
        let newSize = NSSize(width: newWidth, height: newHeight)

        let resizedImage = NSImage(size: newSize)
        resizedImage.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        draw(in: NSRect(origin: .zero, size: newSize),
             from: NSRect(origin: .zero, size: currentSize),
             operation: .copy,
             fraction: 1.0)
        resizedImage.unlockFocus()

        return resizedImage
    }
}
