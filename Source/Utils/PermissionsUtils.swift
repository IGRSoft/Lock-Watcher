//
//  PermissionsUtils.swift
//
//  Created on 26.05.2022.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import AVFoundation
import CoreLocation

/// `PermissionsUtils` is a utility class that facilitates the management of permissions for location and camera services.
public final class PermissionsUtils {
    /// Updates the location services permissions.
    ///
    /// This method checks the current authorization status for location services and if it's undetermined, it sends a request for authorization.
    ///
    /// - Parameter handler: A closure that gets called with a boolean indicating whether access is granted.
    class func updateLocationPermissions(completionHandler handler: @escaping Commons.BoolClosure) {
        // Instantiating the CLLocationManager to get location permissions.
        let locationManager = CLLocationManager()
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            handler(true)
        case .restricted, .denied:
            // Restricted and Denied states indicate that location access was denied or not allowed.
            handler(false)
        case .authorizedAlways:
            // Access is always authorized.
            handler(true)
        @unknown default:
            // For future cases that might be added, currently grant access.
            handler(true)
        }
    }
    
    /// Updates the camera permissions.
    ///
    /// This method checks the current authorization status for camera services and if it's undetermined, it sends a request for authorization.
    ///
    /// - Parameter handler: A closure that gets called with a boolean indicating whether access is granted.
    class func updateCameraPermissions(completionHandler handler: @escaping Commons.BoolClosure) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                handler(isGranted)
            }
        case .restricted, .denied:
            // Restricted and Denied states indicate that camera access was denied or not allowed.
            handler(false)
        case .authorized:
            // Access is authorized.
            handler(true)
        @unknown default:
            // For future cases that might be added, currently grant access.
            handler(true)
        }
    }
}
