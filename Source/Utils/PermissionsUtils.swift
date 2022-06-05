//
//  PermissionsUtils.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.05.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import AppKit
import CoreLocation
import AVFoundation

class PermissionsUtils {
    class func updateLocationPermissions(completionHandler handler: @escaping (Bool) -> Void) {
        let locationManager = CLLocationManager()
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            handler(true)
        case .restricted, .denied:
            handler(false)
        case .authorizedAlways:
            handler(true)
        @unknown default:
            handler(true)
        }
    }
    
    class func updateCameraPermissions(completionHandler handler: @escaping (Bool) -> Void) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                handler(isGranted)
            }
        case .restricted, .denied:
            handler(false)
        case .authorized:
            handler(true)
        @unknown default:
            handler(true)
        }
    }
}
