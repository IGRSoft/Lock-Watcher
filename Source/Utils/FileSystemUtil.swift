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
public final class FileSystemUtil: FileSystemUtilProtocol {
    //MARK: - Dependency Injection
    
    /// A logger instance for logging various events and errors.
    private let logger: LogProtocol
    
    /// A name of folder in Documents directory
    private let dirName: String
    
    //MARK: - Initialiser
    
    /// Initializes a new `FileSystemUtil`.
    ///
    /// - Parameter logger: A logger instance. Defaults to a logger with the category `.fileSystem`.
    init(dirName: String = "Lock-Watcher", logger: LogProtocol = Log(category: .fileSystem)) {
        self.dirName = dirName
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
        let data = image.jpegData
        
        guard !data.isEmpty else {
            logger.debug("error saving empty data for key: \(key)")
            return nil
        }
        
        if let filePath = filePath(forKey: key) {
            do {
                try data.write(to: filePath)
            }
            catch {
                logger.debug("error saving: \(error.localizedDescription)\n for key: \(key)")
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
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let dirURL = documentURL.appendingPathComponent(dirName)
        
        // Create the "Lock-Watcher" directory if it doesn't exist.
        if fileManager.fileExists(atPath: dirURL.path) == false {
            do {
                try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
            }
            catch {
                logger.debug("error saving: \(error.localizedDescription)")
                return nil
            }
        }
        
        // Return the full file path for the jpeg image.
        return dirURL.appendingPathComponent(key, conformingTo: .jpeg)
    }
}
