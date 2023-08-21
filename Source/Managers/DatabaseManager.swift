//
//  DatabaseNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.08.2021.
//

import Foundation
import EasyStash
import Combine

protocol DatabaseManagerProtocol: ObservableObject {
    func send(_ thiefDto: ThiefDto) -> DatabaseDtoList
    
    func remove(_ dto: DatabaseDto) -> DatabaseDtoList
    
    var latestImages: [DatabaseDto] { get }
    
    var latestImagesPublisher: Published<[DatabaseDto]>.Publisher { get }
}

final class DatabaseManager: DatabaseManagerProtocol {
    
    //MARK: - Dependency injection
    private var settings: any AppSettingsProtocol
    
    //MARK: - Variables
    
    private let kImagesKey = "images"
    
    private var storage: Storage? = nil
    
    @Published private(set) var latestImages: [DatabaseDto] = .init()
    
    //MARK: - Combine
    
    var latestImagesPublisher: Published<[DatabaseDto]>.Publisher { $latestImages }
    
    //MARK: - initialiser
    
    init(settings: any AppSettingsProtocol) {
        self.settings = settings
        
        var options: Options = Options()
        options.folder = "Thiefs"
        
        storage = try? Storage(options: options)
        
        latestImages.append(contentsOf: readImages().dtos)
    }
    
    //MARK: - public
    
    func send(_ thiefDto: ThiefDto) -> DatabaseDtoList {
        let dto = DatabaseDto(with: thiefDto)
        
        let images = readImages()
        
        images.append(dto)
        images.dtos = images.dtos.suffix(settings.options.keepLastActionsCount)
        
        do {
            try storage?.save(object: images, forKey: kImagesKey)
        } catch {
            print(error)
            return images
        }
        
        latestImages = images.dtos
        
        return images
    }
    
    func remove(_ dto: DatabaseDto) -> DatabaseDtoList {
        let images = readImages()
        
        images.dtos.removeAll {$0.date == dto.date}
        
        do {
            try storage?.save(object: images, forKey: kImagesKey)
        } catch {
            print(error)
        }
        
        latestImages = images.dtos
        
        return images
    }
    
    //MARK: - private
    
    private func readImages() -> DatabaseDtoList {
        var images: DatabaseDtoList = DatabaseDtoList(dtos: .init())
        do {
            if let imgs = try storage?.load(forKey: kImagesKey, as: DatabaseDtoList.self) {
                images = imgs
            }
        } catch {
            print("images is empty")
        }
        
        return images
    }
}

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
