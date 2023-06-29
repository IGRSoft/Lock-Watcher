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

protocol ThiefManagerProtocol: ObservableObject {
    
}

class ThiefManager: NSObject, ThiefManagerProtocol{
    typealias WatchBlock = ((ThiefDto) -> Void)
    
    private let notificationManager: NotificationManager
    public let objectWillChange = ObservableObjectPublisher()
    
    private(set) var settings: (any AppSettingsProtocol)
    
    private var lastThiefDetection = ThiefDto()
    @Published var databaseManager: DatabaseManager
    private let networkUtil = NetworkUtil()
    
    private var watchBlock: WatchBlock = {_ in}
    
    lazy var triggerManager = TriggerManager()
    
    private(set) var locationManager = CLLocationManager()
    private var coordinate: CLLocationCoordinate2D?
    
    init(settings: (any AppSettingsProtocol), watchBlock: @escaping WatchBlock = {_ in}) {
        self.settings = settings
        
        notificationManager = NotificationManager(settings: settings)
        
        databaseManager = DatabaseManager(settings: settings)
        
        super.init()
        
        self.watchBlock = watchBlock
                
        if (settings.options.addLocationToSnapshot) {
            setupLocationManager(enable: true)
        }
        
        startWatching(watchBlock)
        
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
        triggerManager.start(settings: settings) {[weak self] trigered in
            watchBlock(trigered)
            
            if trigered.triggerType != .setup {
                DispatchQueue.main.async {
                    self?.lastThiefDetection.triggerType = trigered.triggerType
                    self?.detectedTrigger()
                }
            }
            
            self?.startWatching(watchBlock)
        }
    }
    
    public func stopWatching() {
        os_log(.debug, "Stop Watching")
        triggerManager.stop()
    }
    
    public func restartWatching() {
        triggerManager.start(settings: settings) {[weak self] trigered in
            self?.watchBlock(trigered)
        }
    }
    
    public func detectedTrigger(_ closure: @escaping (Bool) -> Void = {_ in }) {
        os_log(.debug, "Detected trigered action: \(self.lastThiefDetection.triggerType.rawValue)")
        let ps = PhotoSnap()
        ps.photoSnapConfiguration.isSaveToFile = settings.sync.isSaveSnapshotToDisk
        guard !AppSettings.isDebug else {
            let img = NSImage(systemSymbolName: "swift", accessibilityDescription: nil)!
            let date = Date()
            lastThiefDetection.triggerType = .debug
            processSnapshot(img, filename: ps.photoSnapConfiguration.dateFormatter.string(from: date), date: date)
            DispatchQueue.main.debounce(interval: .seconds(1)) {
                closure(true)
            }()
            
            return
        }
        
        ps.fetchSnapshot() { [weak self] photoModel in
            if let img = photoModel.images.last {
                os_log(.debug, "\(img)")
                let date = Date()
                self?.processSnapshot(img, filename: ps.photoSnapConfiguration.dateFormatter.string(from: date), date: date)
                
                closure(true)
            } else {
                closure(false)
            }
        }
    }
    
    func processSnapshot(_ snapshot: NSImage, filename: String, date: Date) {
        guard let filepath = FileSystemUtil.store(image: snapshot, forKey: filename) else {
            assert(false, "wrong file path")
            return
        }
        
        lastThiefDetection.snapshot = snapshot
        lastThiefDetection.date = date
        lastThiefDetection.coordinate = coordinate
        lastThiefDetection.filepath = filepath
        
        let compleate:(ThiefDto) -> () = { [weak self] dto in
            
            let _ = self?.notificationManager.send(dto)
            let _ = self?.databaseManager.send(dto)
            
            self?.objectWillChange.send()
            
            self?.watchBlock(dto)
        }
        
        if settings.options.addIPAddressToSnapshot {
            lastThiefDetection.ipAddress = networkUtil.getIFAddresses()
        }
        
        if settings.options.addTraceRouteToSnapshot {
            networkUtil.getTraceRoute(host: settings.options.traceRouteServer) { [weak self] traceRouteLog in
                guard let lastThiefDetection = self?.lastThiefDetection else {
                    assert(false, "wrong dto")
                    return
                }
                
                lastThiefDetection.traceRoute = traceRouteLog
                compleate(lastThiefDetection)
            }
        } else {
            compleate(lastThiefDetection)
        }
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
        self.coordinate = locations.last?.coordinate
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
