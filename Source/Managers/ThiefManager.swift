//
//  ThiefManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import PhotoSnap

class ThiefManager {
    typealias WatchBlock = ((Bool) -> Void)
    
    private let notificationManager = NotificationManager()
    
    private var settings: SettingsDto {
        return SettingsDto()
    }
    
    private var watchBlock: WatchBlock = {trigered in}
    
    lazy var trigerManager: TrigerManager = {
        let manager = TrigerManager(settings: self.settings)
        return manager
    }()
    
    public func startWatching(_ watchBlock: @escaping WatchBlock = {trigered in}) {
        stopWatching()
        
        self.watchBlock = watchBlock
        trigerManager.start() {trigered in
            watchBlock(trigered)
            
            if trigered == true {
                let ps = PhotoSnap()
                ps.photoSnapConfiguration.isSaveToFile = true
                ps.fetchSnapshot() { photoModel in
                    if let img = photoModel.images.last {
                        print("\(img)")
                    }
                    
                    if let picturePath = photoModel.pathes.last {
                        print("\(picturePath.absoluteString)")
                    }
                }
            }
            
            self.startWatching(watchBlock)
        }
    }
    
    public func stopWatching() {
        trigerManager.stop()
    }
    
    fileprivate func restartWatching() {
        trigerManager.stop()
        trigerManager.start() {trigered in
            self.watchBlock(trigered)
        }
    }
}
