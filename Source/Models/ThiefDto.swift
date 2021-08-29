//
//  ThiefDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import CoreLocation
import AppKit

public class ThiefDto: Equatable {
    public static func == (lhs: ThiefDto, rhs: ThiefDto) -> Bool {
        return lhs.date == rhs.date
    }
    
    enum TrigerType {
        case empty, onWakeUp, onWrongPassword, onBatteryPower, usbConnected
    }
    
    var coordinate: CLLocationCoordinate2D?
    var trigerType: TrigerType? = .empty
    var snapshot: NSImage?
    var filepath: URL?
    var date: Date = Date()
}
