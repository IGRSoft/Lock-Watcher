//
//  ThiefManager.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import AppKit
import PhotoSnap
import Combine
import CoreLocation
import UserNotifications

/// A protocol that outlines the responsibilities of the `ThiefManager` class.
protocol ThiefManagerProtocol {
    func detectedTrigger(_ closure: @escaping Commons.BoolClosure)
    
    func restartWatching()
    
    var databaseManager: any DatabaseManagerProtocol { get }
    
    func setupLocationManager(enable: Bool)
    
    func showSnapshot(identifier: String)
    
    func completeDropboxAuthWith(url: URL)
    
    func watchDropboxUserNameUpdate(_ closure: @escaping Commons.StringClosure)
}

/// The main class responsible for managing and responding to various triggers indicating potential unauthorized access.
final class ThiefManager: NSObject, ThiefManagerProtocol {
    
    //MARK: - Typealiases
    
    typealias WatchBlock = ((ThiefDto) -> Void)
    
    //MARK: - Dependency injection
    
    private var triggerManager: TriggerManagerProtocol
    
    private let notificationManager: NotificationManagerProtocol
    
    private var watchBlock: WatchBlock = { _ in }
    
    private(set) var settings: any AppSettingsProtocol
    
    private var logger: Log
    
    //MARK: - Variables
    
    private var lastThiefDetection = ThiefDto()
    
    /// store ThiefDto in database
    ///
    var databaseManager: any DatabaseManagerProtocol
    
    /// fetch ip address and trace route
    ///
    private lazy var networkUtil: NetworkUtilProtocol = NetworkUtil()
    
    private lazy var fileSystemUtil: FileSystemUtilProtocol = FileSystemUtil()
    
    /// fetch current location
    ///
    private(set) var locationManager = CLLocationManager()
    private var coordinate: CLLocationCoordinate2D?
    
    /// update user name after login on DropBox
    private var dropboxUserNameUpdateClosure: Commons.StringClosure?
    
    //MARK: - initialiser
    
    init(settings: any AppSettingsProtocol, triggerManager: TriggerManagerProtocol = TriggerManager(), logger: Log = .init(category: .thiefManager), watchBlock: @escaping WatchBlock = { _ in }) {
        self.settings = settings
        self.triggerManager = triggerManager
        self.watchBlock = watchBlock
        self.logger = logger
        
        notificationManager = NotificationManager(settings: settings)
        
        databaseManager = DatabaseManager(settings: settings)
        
        super.init()
        
        if (settings.options.addLocationToSnapshot) {
            setupLocationManager(enable: true)
        }
        
        startWatching(watchBlock)
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    //MARK: - public
    
    /// These methods define how the manager should behave when various events occur.
    /// Sets up the location manager, either enabling or disabling location updates.
    public func setupLocationManager(enable: Bool) {
        if enable {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        } else {
            locationManager.delegate = nil
            locationManager.stopUpdatingLocation()
        }
    }
    
    /// Stops watching for triggers.
    public func stopWatching() {
        logger.debug("Stop Watching")
        triggerManager.stop()
    }
    
    /// Restarts the trigger watching mechanism
    public func restartWatching() {
        triggerManager.start(settings: settings) {[weak self] triggered in
            self?.watchBlock(triggered)
        }
    }
    
    /// Detects and processes any triggers.
    public func detectedTrigger(_ closure: @escaping Commons.BoolClosure = {_ in }) {
        logger.debug("Detected triggered action: \(self.lastThiefDetection.triggerType.rawValue)")
        
        let ps = PhotoSnap()
        ps.photoSnapConfiguration.isSaveToFile = settings.sync.isSaveSnapshotToDisk
        guard !AppSettings.isImageCaptureDebug else {
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
                self?.logger.debug("\(img)")
                let date = Date()
                self?.processSnapshot(img, filename: ps.photoSnapConfiguration.dateFormatter.string(from: date), date: date)
                
                closure(true)
            } else {
                closure(false)
            }
        }
    }
    
    ///Processes a given snapshot.
    func processSnapshot(_ snapshot: NSImage, filename: String, date: Date) {
        guard let filePath = fileSystemUtil.store(image: snapshot, forKey: filename) else {
            let msg = "wrong file path"
            logger.error(msg)
            assert(false, msg)
            return
        }
        
        lastThiefDetection.snapshot = snapshot
        lastThiefDetection.date = date
        lastThiefDetection.coordinate = coordinate
        lastThiefDetection.filePath = filePath
        
        let complete:(ThiefDto) -> () = { [weak self] dto in
            let _ = self?.notificationManager.send(dto)
            let _ = self?.databaseManager.send(dto)
            
            self?.watchBlock(dto)
        }
        
        if settings.options.addIPAddressToSnapshot {
            lastThiefDetection.ipAddress = networkUtil.getIFAddresses()
        }
        
        if settings.options.addTraceRouteToSnapshot {
            networkUtil.getTraceRoute(host: settings.options.traceRouteServer) { [weak self] traceRouteLog in
                guard let lastThiefDetection = self?.lastThiefDetection else {
                    let msg = "wrong DTO"
                    self?.logger.error(msg)
                    assert(false, msg)
                    return
                }
                
                lastThiefDetection.traceRoute = traceRouteLog
                complete(lastThiefDetection)
            }
        } else {
            complete(lastThiefDetection)
        }
    }
    
    /// Opens a snapshot based on the given identifier.
    func showSnapshot(identifier: String) {
        if let filePath = databaseManager.latestImages.first(where: { Date.defaultFormat.string(from: $0.date) == identifier })?.path {
            NSWorkspace.shared.open(filePath)
        }
    }
    
    //MARK: - private
    
    /// Starts watching for triggers.
    private func startWatching(_ watchBlock: @escaping WatchBlock = { triggered in} ) {
        
        logger.debug("Start Watching")
        
        self.watchBlock = watchBlock
        triggerManager.start(settings: settings) {[weak self] triggered in
            watchBlock(triggered)
            
            if triggered.triggerType != .setup {
                DispatchQueue.main.async {
                    self?.lastThiefDetection.triggerType = triggered.triggerType
                    self?.detectedTrigger()
                }
            }
            
            self?.startWatching(watchBlock)
        }
    }
    
    /// Completes Dropbox authentication.
    func completeDropboxAuthWith(url: URL) {
        notificationManager.completeDropboxAuthWith(url: url) { [weak self] name in
            self?.dropboxUserNameUpdateClosure?(name)
        }
    }
    
    /// Watches for Dropbox username updates.
    func watchDropboxUserNameUpdate(_ closure: @escaping Commons.StringClosure) {
        dropboxUserNameUpdateClosure = closure
    }
}

/// Location Manager Delegate Methods
extension ThiefManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.coordinate = locations.last?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.debug("\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var statusName = "Unknown"
        switch status {
        case .restricted:
            statusName = "restricted"
        case .denied:
            statusName = "denied"
        case .authorized:
            statusName = "authorised"
        case .notDetermined:
            statusName = "not yet determined"
        default:
            break
        }
        
        logger.debug("location manager auth status changed to: \(statusName)")
    }
}

/// User Notification Center Delegate Methods:
extension ThiefManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ centre: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let identifier = response.notification.request.identifier;
        showSnapshot(identifier: identifier)
    }
}

class ThiefManagerPreview: ThiefManagerProtocol {
    func watchDropboxUserNameUpdate(_ closure: @escaping Commons.StringClosure) {
        closure("")
    }
    
    func completeDropboxAuthWith(url: URL) {
    }
    
    func showSnapshot(identifier: String) {
    }
    
    func setupLocationManager(enable: Bool) {
    }
    
    func detectedTrigger(_ closure: @escaping Commons.BoolClosure) {
        closure(true)
    }
    
    func restartWatching() {
    }
    
    var databaseManager: any DatabaseManagerProtocol = DatabaseManager(settings: AppSettingsPreview())
}
