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

class ThiefManager: NSObject, ObservableObject {
    typealias WatchBlock = ((ThiefDto) -> Void)
    
    private let notificationManager = NotificationManager()
    
    @Published var settings = SettingsDto.current()
    
    private var _lastThiefDetection = ThiefDto()
    public var lastThiefDetection: ThiefDto {
        return _lastThiefDetection
    }
    
    private var watchBlock: WatchBlock = {trigered in}
    
    lazy var trigerManager = TrigerManager()
    
    private var locationManager = CLLocationManager()
    
    init(_ watchBlock: @escaping WatchBlock = {trigered in}) {
        super.init()
        
        self.setupLocationManager()
        self.startWatching(watchBlock)
        
        detectedTriger()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    public func startWatching(_ watchBlock: @escaping WatchBlock = {trigered in}) {
        os_log(.debug, "Start Watching")
        
        self.watchBlock = watchBlock
        trigerManager.start(settings: settings) {[unowned self] trigered in
            watchBlock(trigered)
            
            if trigered.trigerType != .empty {
                DispatchQueue.main.async {
                    self._lastThiefDetection.trigerType = trigered.trigerType
                    self.detectedTriger()
                }
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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss.SSS"
        self.processSnapshot(NSImage(systemSymbolName: "swift", accessibilityDescription: "swift")!,
                             filename: dateFormatter.string(from: Date()))
        #else
        let ps = PhotoSnap()
        ps.photoSnapConfiguration.isSaveToFile = true
        ps.fetchSnapshot() { [unowned self] photoModel in
            if let img = photoModel.images.last {
                os_log(.debug, "\(img)")
                self.processSnapshot(img, filename: ps.photoSnapConfiguration.dateFormatter.string(from: Date()))
            }
        }
        #endif
    }
    
    func processSnapshot(_ snapshot: NSImage, filename: String) {
        _lastThiefDetection.snapshot = snapshot
        let filepath = FileSystemUtil.store(image: snapshot, forKey: filename)
        let _ = notificationManager.send(photo: filepath?.path,
                                         to: self.settings.mailRecipient,
                                         coordinate: _lastThiefDetection.coordinate)
    }
}

extension ThiefManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self._lastThiefDetection.coordinate = locations.last!.coordinate
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
