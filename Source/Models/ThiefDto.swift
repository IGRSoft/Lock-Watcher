//
//  ThiefDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import CoreLocation
import AppKit

enum TriggerType: String {
    case setup, onWakeUp, onWrongPassword, onBatteryPower, usbConnected, logedIn, debug
}

extension TriggerType {
    var info: String {
        return NSLocalizedString("TrigerType_\(self.rawValue)", comment: "")
    }
}

public class ThiefDto: Equatable {
    public static func == (lhs: ThiefDto, rhs: ThiefDto) -> Bool {
        return lhs.date == rhs.date
    }
    
    var coordinate: CLLocationCoordinate2D?
    var ipAddress: String?
    var traceRoute: String?
    var triggerType: TriggerType = .setup
    var snapshot: NSImage?
    var filepath: URL?
    var date: Date = Date()
    
    func info() -> String {
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
