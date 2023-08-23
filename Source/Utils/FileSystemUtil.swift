//
//  FileSystemUtil.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import AppKit

/// `FileSystemUtilProtocol` provides an interface for storing images on the local file system.
protocol FileSystemUtilProtocol {
    /// Store the provided image in the file system.
    ///
    /// - Parameters:
    ///   - image: The `NSImage` to be stored.
    ///   - key: A unique identifier for the image.
    /// - Returns: The URL where the image is stored, or nil if there was an error.
    func store(image: NSImage, forKey key: String) -> URL?
}

/// `FileSystemUtil` provides utilities for interacting with the local file system, specifically for storing images.
public class FileSystemUtil: FileSystemUtilProtocol {
    //MARK: - Dependency Injection
    
    /// A logger instance for logging various events and errors.
    private var logger: Log
    
    //MARK: - Initialiser
    
    /// Initializes a new `FileSystemUtil`.
    ///
    /// - Parameter logger: A logger instance. Defaults to a logger with the category `.fileSystem`.
    init(logger: Log = Log(category: .fileSystem)) {
        self.logger = logger
    }
    
    //MARK: - Public methods
    
    /// Save an image to the User's Document directory under a specified subdirectory named "Lock-Watcher" as a jpeg file.
    ///
    /// - Parameters:
    ///   - image: The `NSImage` to be stored.
    ///   - key: A unique identifier for the image. This is used to name the jpeg file.
    /// - Returns: The URL where the image is stored, or nil if there was an error.
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
    
    //MARK: - Private helper methods
    
    /// Generate a file path based on a given trigger key. This file path points to a jpeg file under the "Lock-Watcher" directory in the user's documents.
    ///
    /// - Parameter key: The unique trigger key.
    /// - Returns: The URL for the jpeg file, or nil if there was an error.
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard var documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        documentURL = documentURL.appendingPathComponent("Lock-Watcher")
        
        // Create the "Lock-Watcher" directory if it doesn't exist.
        if fileManager.fileExists(atPath: documentURL.path) == false {
            do {
                try fileManager.createDirectory(at: documentURL, withIntermediateDirectories: true)
            }
            catch {
                logger.debug("error saving: \(error.localizedDescription)")
                return nil
            }
        }
        
        // Return the full file path for the jpeg image.
        return documentURL.appendingPathComponent(key, conformingTo: .jpeg)
    }
}
