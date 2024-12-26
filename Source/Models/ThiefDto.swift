//
//  ThiefDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import Foundation
import CoreLocation
import AppKit

/// An enumeration that defines all the trigger types available in the application.
///
public enum TriggerType: String, Sendable {
    case setup
    case onWakeUp
    case onWrongPassword
    case onBatteryPower
    case usbConnected
    case logedIn
    case debug
}

extension TriggerType {
    
    /// Provides a localized name for each trigger type.
    var name: String {
        return NSLocalizedString("TriggerType_\(self.rawValue)", comment: "")
    }
}

/// Represents a data object that captures information during a trigger action.
/// This object might be used when there's suspicion of unauthorized access or other security breaches.
///
public final class ThiefDto: Equatable, Sendable {
    
    /// Equatability implementation for the ThiefDto class.
    public static func == (lhs: ThiefDto, rhs: ThiefDto) -> Bool {
        return lhs.date == rhs.date
    }
    
    /// The current coordinate of the device when the trigger action occurred.
    let coordinate: CLLocationCoordinate2D?
    
    /// The IP address of the session when the trigger action occurred.
    let ipAddress: String?
    
    /// The trace route of the session during the trigger action.
    /// Trace route provides a sequence of routes that network packets take when moving between source and destination.
    let traceRoute: String?
    
    /// The type of trigger that caused the action.
    let triggerType: TriggerType
    
    /// An image taken from the device's camera during the trigger action.
    let snapshot: NSImage?
    
    /// The file location where the image is stored.
    let filePath: URL?
    
    /// The date and time when the trigger action occurred.
    let date: Date
    
    init(triggerType: TriggerType, coordinate: CLLocationCoordinate2D? = nil, ipAddress: String? = nil, traceRoute: String? = nil, snapshot: NSImage? = nil, filePath: URL? = nil, date: Date = .init()) {
        self.coordinate = coordinate
        self.ipAddress = ipAddress
        self.traceRoute = traceRoute
        self.triggerType = triggerType
        self.snapshot = snapshot
        self.filePath = filePath
        self.date = date
    }
    
    /// Provides a textual description of the ThiefDto object.
    /// It's useful for logging or presenting the data to the user in a readable format.
    ///
    func description() -> String {
        var objects = [String]()
        
        // Format the coordinate into a string representation.
        if let coordinate = coordinate {
            var info = String(describing: coordinate)
            
            // Extracts coordinate details from the description string.
            if let coordinatesItems = info.matches(for: "\\((.*?)\\)"), let coordinates = coordinatesItems.first  {
                info = coordinates
            }
            objects.append(info)
        }
        
        // Adds the IP address to the description if available.
        if let ipAddress = ipAddress {
            objects.append("ip: \(ipAddress)")
        }
        
        // Adds the trace route to the description if available.
        if let traceRoute = traceRoute {
            objects.append(traceRoute)
        }
        
        // Combines and returns the formatted information as a single string.
        return objects.joined(separator: "\n")
    }
}
