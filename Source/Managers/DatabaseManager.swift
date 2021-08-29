//
//  DatabaseNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.08.2021.
//

import Foundation
import EasyStash

class DatabaseManager: Equatable {
    public static func == (lhs: DatabaseManager, rhs: DatabaseManager) -> Bool {
        return lhs.storage?.folderUrl == rhs.storage?.folderUrl
    }
    
    private let kImagesKey = "images"
    
    private var settings: AppSettings?
    
    private var storage: Storage? = nil
    
    init() {
        var options: Options = Options()
        options.folder = "Thiefs"
        
        storage = try? Storage(options: options)
    }
    
    func setupSettings(_ settings: AppSettings?) {
        self.settings = settings
    }
    
    func send(_ thiefDto: ThiefDto) -> Bool {
        let dto = DatabaseDto(with: thiefDto)
        
        var images = latestImages()
        
        images.append(dto)
        images = images.suffix(settings?.keepLastActionsCount ?? 10)
        
        do {
            try storage?.save(object: images, forKey: kImagesKey)
        } catch {
            print(error)
            return false
        }
        
        return true
    }
    
    func latestImages() -> [DatabaseDto] {
        var images: [DatabaseDto] = [DatabaseDto]()
        do {
            if let imgs = try storage?.load(forKey: kImagesKey, as: [DatabaseDto].self) {
                images.append(contentsOf: imgs)
            }
        } catch {
            print("images is empty")
        }
        
        return images
    }
}
