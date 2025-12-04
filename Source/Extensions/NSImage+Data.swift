//
//  NSImage+Data.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    /// Represents the `NSImage` as JPEG data.
    ///
    /// This computed property attempts to convert the `NSImage` instance into JPEG data format.
    /// The compression factor is set to 0.9, which indicates a relatively high-quality JPEG.
    ///
    /// - Returns: Data representation of the image in JPEG format. If the conversion fails, it returns an empty Data instance.
    var jpegData: Data {
        // Convert the NSImage into TIFF representation.
        guard let tiffData = tiffRepresentation, let bitmap = NSBitmapImageRep(data: tiffData) else {
            // Return empty data if conversion to TIFF representation fails.
            return Data()
        }
        
        // Convert the TIFF representation to JPEG data with a compression factor of 0.9.
        guard let data = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.9]) else {
            // Return empty data if conversion to JPEG data fails.
            return Data()
        }
        
        // Return the JPEG data.
        return data
    }
}
