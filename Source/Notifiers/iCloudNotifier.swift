//
//  iCloudNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 10.08.2021.
//

import AppKit
import CoreLocation

class iCloudNotifier {
    
    func send(photo path: String, coordinate: CLLocationCoordinate2D) -> Bool {
        let localURL = URL(fileURLWithPath: path)
        
        guard var iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            assert(false, "Wrong urls")
            return false
        }
        
        iCloudURL.appendPathComponent(localURL.lastPathComponent)
        
        var image = NSImage(contentsOf: localURL)
        image = image?.imageWithText(text: String(describing: coordinate))
        
        do {
            let data = image?.tiffRepresentation
            if FileManager.default.fileExists(atPath: localURL.path) {
                try FileManager.default.removeItem(at: localURL)
            }
            try data?.write(to: iCloudURL)
        } catch let error  {
            print(error)
        }
        
        return true
    }
}
