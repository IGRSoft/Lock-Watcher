//
//  FileSystemUtil.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import AppKit
import os

class FileSystemUtil {
    class private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard var documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        documentURL = documentURL.appendingPathComponent("Lock-Watcher")
        
        let fm = FileManager.default
        if fm.fileExists(atPath: documentURL.path) == false {
            do {
                try fm.createDirectory(at: documentURL, withIntermediateDirectories: true)
            }
            catch {
                os_log(.debug, "error saving: \(error.localizedDescription)")
                return nil
            }
        }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    class func store(image: NSImage, forKey key: String) -> URL? {
        if let filePath = filePath(forKey: key) {
            guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil} // TODO: handle error
            let newRep = NSBitmapImageRep(cgImage: cgImage)
            newRep.size = image.size // if you want the same size
            guard let pngData = newRep.representation(using: .png, properties: [:]) else { return nil} // TODO: handle error
            do {
                try pngData.write(to: filePath)
            }
            catch {
                os_log(.debug, "error saving: \(error.localizedDescription)")
                return nil
            }
            
            return filePath
        }
        
        return nil
    }
}
