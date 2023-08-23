//
//  DatabaseNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.08.2021.
//

import Foundation
import EasyStash
import Combine

/// Defines the contract for a database manager with observable latest images.
protocol DatabaseManagerProtocol: ObservableObject {
    func send(_ thiefDto: ThiefDto) -> DatabaseDtoList
    func remove(_ dto: DatabaseDto) -> DatabaseDtoList
    var latestImages: [DatabaseDto] { get }
    var latestImagesPublisher: Published<[DatabaseDto]>.Publisher { get }
}

final class DatabaseManager: DatabaseManagerProtocol {
    
    //MARK: - Dependency injection
    
    /// Holds the application settings.
    private var settings: any AppSettingsProtocol
    
    //MARK: - Variables
    
    /// Key used for storing and retrieving images in the storage.
    private let kImagesKey = "images"
    
    /// Instance of the storage for saving and retrieving data.
    private var storage: Storage? = nil
    
    /// Observable property that stores the latest images.
    @Published private(set) var latestImages: [DatabaseDto] = .init()
    
    //MARK: - Combine
    
    /// Publisher for `latestImages` property to allow observing its changes.
    var latestImagesPublisher: Published<[DatabaseDto]>.Publisher { $latestImages }
    
    //MARK: - initialiser
    
    /// Initializes the database manager with app settings and configures storage options.
    init(settings: any AppSettingsProtocol) {
        self.settings = settings
        
        var options: Options = Options()
        options.folder = "Thiefs"
        
        storage = try? Storage(options: options)
        
        // Load and store the initial set of images from the storage.
        latestImages.append(contentsOf: readImages().dtos)
    }
    
    //MARK: - public
    
    /// Stores the thief incident information in the storage and updates the `latestImages`.
    func send(_ thiefDto: ThiefDto) -> DatabaseDtoList {
        // Convert the received data to the desired format
        let dto = DatabaseDto(with: thiefDto)
        
        // Read the current images from the storage
        let images = readImages()
        
        // Append the new data and keep only the latest specified number of incidents
        images.append(dto)
        images.dtos = images.dtos.suffix(settings.options.keepLastActionsCount)
        
        // Save the updated data to the storage
        do {
            try storage?.save(object: images, forKey: kImagesKey)
        } catch {
            print(error)
            return images
        }
        
        // Update the published images
        latestImages = images.dtos
        
        return images
    }
    
    /// Removes a specific incident from the storage and updates the `latestImages`.
    func remove(_ dto: DatabaseDto) -> DatabaseDtoList {
        let images = readImages()
        
        // Remove the specific incident based on the date
        images.dtos.removeAll {$0.date == dto.date}
        
        // Save the updated data to the storage
        do {
            try storage?.save(object: images, forKey: kImagesKey)
        } catch {
            print(error)
        }
        
        // Update the published images
        latestImages = images.dtos
        
        return images
    }
    
    //MARK: - private
    
    /// Fetches and returns the images from the storage.
    private func readImages() -> DatabaseDtoList {
        var images: DatabaseDtoList = DatabaseDtoList(dtos: .init())
        do {
            // Try to load images from the storage
            if let imgs = try storage?.load(forKey: kImagesKey, as: DatabaseDtoList.self) {
                images = imgs
            }
        } catch {
            print("images is empty")
        }
        
        return images
    }
}

/// A mock version of `DatabaseManager` mainly for previewing or testing purposes.
class DatabaseManagerPreview: DatabaseManagerProtocol {
    func send(_ thiefDto: ThiefDto) -> DatabaseDtoList {
        .empty
    }
    
    func remove(_ dto: DatabaseDto) -> DatabaseDtoList {
        .empty
    }
    
    @Published private(set) var latestImages: [DatabaseDto] = .init()
    
    var latestImagesPublisher: Published<[DatabaseDto]>.Publisher { $latestImages }
}
