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
    //MARK: - Dependency Injection
    
    private var logger: Log
    
    //MARK: - Initialiser
    
    init(logger: Log = Log(category: .fileSystem)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    func store(image: NSImage, forKey key: String) -> URL? {
        if let filePath = filePath(forKey: key) {
            do {
                let data = image.jpegData
                try data.write(to: filePath)
            }
            catch {
                logger.debug("error saving: \(error.localizedDescription)")
                return nil
            }
            
            return filePath
        }
        
        return nil
    }
    
    //MARK: - private
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard var documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        documentURL = documentURL.appendingPathComponent("Lock-Watcher")
        
        if fileManager.fileExists(atPath: documentURL.path) == false {
            do {
                try fileManager.createDirectory(at: documentURL, withIntermediateDirectories: true)
            }
            catch {
                logger.debug("error saving: \(error.localizedDescription)")
                return nil
            }
        }
        
        return documentURL.appendingPathComponent(key + ".jpeg")
    }
}
