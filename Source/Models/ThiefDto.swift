//
//  ThiefDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import CoreLocation
import AppKit

public class ThiefDto: ObservableObject {
    enum TrigerType {
        case empty, onWakeUp, onWrongPassword, onBatteryPower
    }
    
    var coordinate = CLLocationCoordinate2D()
    var trigerType: TrigerType? = .empty
    @Published var snapshot: NSImage?
    var date: Date = Date()
}
