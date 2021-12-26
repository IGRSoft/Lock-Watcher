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
import CoreLocation
import UserNotifications

class ThiefManager: NSObject, ObservableObject {
    typealias WatchBlock = ((ThiefDto) -> Void)
    
    private let notificationManager = NotificationManager()
    public let objectWillChange = ObservableObjectPublisher()
    
    var settings: AppSettings?
    
    private var lastThiefDetection = ThiefDto()
    @Published var databaseManager = DatabaseManager()
    
    private var watchBlock: WatchBlock = {_ in}
    
    lazy var trigerManager = TrigerManager()
    
    private(set) var locationManager = CLLocationManager()
    
    init(_ watchBlock: @escaping WatchBlock = {trigered in}) {
        super.init()
        
        self.watchBlock = watchBlock
        
        settings = AppSettings()
        
        databaseManager.setupSettings(settings)
        
        if (settings?.addLocationToSnapshot == true) {
            setupLocationManager(enable: true)
        }
        
        startWatching(watchBlock)
        notificationManager.setupSettings(settings: settings)
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func setupLocationManager(enable: Bool) {
        if enable {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            locationManager.delegate = nil
            locationManager.stopUpdatingLocation()
        }
    }
    
    private func startWatching(_ watchBlock: @escaping WatchBlock = {trigered in}) {
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
        ps.photoSnapConfiguration.isSaveToFile = settings?.isSaveSnapshotToDisk == true
        #if DEBUG
        let img = NSImage(systemSymbolName: "swift", accessibilityDescription: nil)!
        let date = Date()
        self.processSnapshot(img, filename: ps.photoSnapConfiguration.dateFormatter.string(from: date), date: date)
        #else
        ps.fetchSnapshot() { [weak self] photoModel in
            if let img = photoModel.images.last {
                os_log(.debug, "\(img)")
                let date = Date()
                self?.processSnapshot(img, filename: ps.photoSnapConfiguration.dateFormatter.string(from: date), date: date)
            }
        }
        #endif
    }
    
    func processSnapshot(_ snapshot: NSImage, filename: String, date: Date) {
        lastThiefDetection.snapshot = snapshot
        lastThiefDetection.date = date
        guard let filepath = FileSystemUtil.store(image: snapshot, forKey: filename) else {
            assert(false, "wrong file path")
            return
        }
        
        lastThiefDetection.filepath = filepath
        let _ = notificationManager.send(lastThiefDetection)
        let _ = databaseManager.send(lastThiefDetection)
        
        objectWillChange.send()
        
        watchBlock(lastThiefDetection)
    }
    
    func showSnapshot(identifier: String) {
        if let dto = databaseManager.latestImages().dtos.first(where: { Date.dateFormat.string(from: $0.date) == identifier }) {
            if let filepath = dto.path {
                NSWorkspace.shared.open(filepath)
            }
        }
    }
}

extension ThiefManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastThiefDetection.coordinate = locations.last?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log(.debug, "\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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

extension ThiefManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let identifier = response.notification.request.identifier;
        showSnapshot(identifier: identifier)
    }
}
