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
import Combine

class ThiefManager: NSObject, ObservableObject {
    typealias WatchBlock = ((ThiefDto) -> Void)
    
    private let notificationManager = NotificationManager()
    public let objectWillChange = ObservableObjectPublisher()
    
    @Published var settings = SettingsDto.current()
    
    @Published var lastThiefDetection = ThiefDto()
    
    private var watchBlock: WatchBlock = {trigered in}
    
    lazy var trigerManager = TrigerManager()
    
    private var locationManager = CLLocationManager()
    
    init(_ watchBlock: @escaping WatchBlock = {trigered in}) {
        super.init()
        
        setupLocationManager()
        startWatching(watchBlock)
        notificationManager.setupSettings(settings: settings)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    public func startWatching(_ watchBlock: @escaping WatchBlock = {trigered in}) {
        os_log(.debug, "Start Watching")
        
        self.watchBlock = watchBlock
        trigerManager.start(settings: settings) {[weak self] trigered in
            watchBlock(trigered)
            
            if trigered.trigerType != .empty {
                DispatchQueue.main.async {
                    self?.lastThiefDetection.trigerType = trigered.trigerType
                    self?.detectedTriger()
                }
            }
            
            self?.startWatching(watchBlock)
        }
    }
    
    public func stopWatching() {
        os_log(.debug, "Stop Watching")
        trigerManager.stop()
    }
    
    public func restartWatching() {
        trigerManager.start(settings: settings) {[weak self] trigered in
            self?.watchBlock(trigered)
        }
    }
    
    public func detectedTriger() {
        os_log(.debug, "Detected trigered action")
        let ps = PhotoSnap()
        ps.photoSnapConfiguration.isSaveToFile = true
        ps.fetchSnapshot() { [weak self] photoModel in
            if let img = photoModel.images.last {
                os_log(.debug, "\(img)")
                let date = Date()
                self?.processSnapshot(img, filename: ps.photoSnapConfiguration.dateFormatter.string(from: date), date: date)
            }
        }
    }
    
    func processSnapshot(_ snapshot: NSImage, filename: String, date: Date) {
        lastThiefDetection.snapshot = snapshot
        lastThiefDetection.date = date
        guard let filepath = FileSystemUtil.store(image: snapshot, forKey: filename) else {
            assert(false, "wrong file path")
            return
        }
        let _ = notificationManager.send(photo: filepath.path,
                                         coordinate: lastThiefDetection.coordinate)
        
        objectWillChange.send()
    }
}

extension ThiefManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastThiefDetection.coordinate = locations.last!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log(.debug, "\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        os_log(.debug, "location manager auth status changed to: " )
        switch status {
        case .restricted:
            os_log(.debug, "restricted")
        case .denied:
            os_log(.debug, "denied")
        case .authorized:
            os_log(.debug, "authorized")
        case .notDetermined:
            os_log(.debug, "not yet determined")
        default:
            os_log(.debug, "Unknown")
        }
    }
}
