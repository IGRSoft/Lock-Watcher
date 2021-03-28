//
//  ThiefDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import CoreLocation
import AppKit

public class ThiefDto {
    enum TrigerType {
        case empty, onWakeUp, onWrongPassword, onBatteryPower
    }
    
    var coordinate = CLLocationCoordinate2D()
    var trigerType: TrigerType? = .empty
    var snapshot = NSImage(systemSymbolName: "swift", accessibilityDescription: "swift")!
    var date: Date = Date()
}
