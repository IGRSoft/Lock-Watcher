//
//  NSImage+Data.swift
//  IGR Software
//
//  Created by Vitalii P on 29.06.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage {
    
    /// Represent Image as jpeg Data
    ///
    /// return data of image on success and
    /// empty data on fault
    ///
    var jpegData: Data {
        guard let tiffData = self.tiffRepresentation, let bitmap: NSBitmapImageRep = NSBitmapImageRep(data: tiffData) else {
            return Data()
        }
        
        guard let data = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.9]) else {
            return Data()
        }
        
        return data
    }
}
