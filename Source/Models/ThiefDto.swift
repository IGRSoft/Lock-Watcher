//
//  ThiefDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import CoreLocation
import AppKit

enum TrigerType: String {
    case empty, onWakeUp, onWrongPassword, onBatteryPower, usbConnected, logedIn
}

extension TrigerType {
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
    var trigerType: TrigerType = .empty
    var snapshot: NSImage?
    var filepath: URL?
    var date: Date = Date()
    
    func info() -> String {
        var info = ""
        
        if let coordinate = coordinate {
            info = String(describing: coordinate)
        }
        
        if let ipAddress = ipAddress {
            info += " \(ipAddress)"
        }
        
        return info
    }
}
