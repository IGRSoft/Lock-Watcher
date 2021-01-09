//
//  ThiefManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import AppKit
import os
import PhotoSnap

class ThiefManager: ObservableObject {
    typealias WatchBlock = ((Bool) -> Void)
    
    private let notificationManager = NotificationManager()
    
    @Published var settings = SettingsDto.current()
    
    private var watchBlock: WatchBlock = {trigered in}
    
    lazy var trigerManager = TrigerManager()
    
    init() {
        self.startWatching()
    }
    
    public func startWatching(_ watchBlock: @escaping WatchBlock = {trigered in}) {
        os_log(.debug, "Start Watching")
        
        self.watchBlock = watchBlock
        trigerManager.start(settings: settings) {[unowned self] trigered in
            watchBlock(trigered)
            
            if trigered == true {
                self.detectedTriger()
            }
            
            self.startWatching(watchBlock)
        }
    }
    
    public func stopWatching() {
        os_log(.debug, "Stop Watching")
        trigerManager.stop()
    }
    
    public func restartWatching() {
        trigerManager.start(settings: settings) {[unowned self] trigered in
            self.watchBlock(trigered)
        }
    }
    
    public func detectedTriger() {
        os_log(.debug, "Detected trigered action")
#if DEBUG
        self.processSnapshot(NSImage())
#else
        let ps = PhotoSnap()
        ps.photoSnapConfiguration.isSaveToFile = true
        ps.fetchSnapshot() { [unowned self] photoModel in
            if let img = photoModel.images.last {
                os_log(.debug, "\(img)")
                self.processSnapshot(img)
            }
        }
#endif
    }
    
    func processSnapshot(_ snapshot: NSImage) {
        notificationManager.send(photo: snapshot, message: "test")
    }
}
