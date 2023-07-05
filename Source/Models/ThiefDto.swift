//
//  ThiefDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import CoreLocation
import AppKit

/// list of all triggers in app
///
enum TriggerType: String {
    case setup, onWakeUp, onWrongPassword, onBatteryPower, usbConnected, logedIn, debug
}

extension TriggerType {
    var name: String {
        return NSLocalizedString("TrigerType_\(self.rawValue)", comment: "")
    }
}

/// Object that contains all data on trigger action
///
public class ThiefDto: Equatable {
    public static func == (lhs: ThiefDto, rhs: ThiefDto) -> Bool {
        return lhs.date == rhs.date
    }
    
    // current coordinate of device
    var coordinate: CLLocationCoordinate2D?
    
    // ip address of session
    var ipAddress: String?
    
    // trace route of session
    var traceRoute: String?
    
    // trigger type
    var triggerType: TriggerType = .setup
    
    // image from camera
    var snapshot: NSImage?
    
    // image file location
    var filePath: URL?
    
    // data of image
    var date: Date = Date()
    
    /// information about object
    /// 
    func description() -> String {
        var objects = [String]()
        
        if let coordinate = coordinate {
            var info = String(describing: coordinate)
            
            if let coordinatesItems = info.matches(for: "\\((.*?)\\)"), let coordinates = coordinatesItems.first  {
                info = coordinates
            }
            objects.append(info)
        }
        
        if let ipAddress = ipAddress {
            objects.append("ip: \(ipAddress)")
        }
        
        if let traceRoute = traceRoute {
            objects.append(traceRoute)
        }
        
        return objects.joined(separator: "\n")
    }
}
