//
//  iCloudNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 10.08.2021.
//

import AppKit
import CoreLocation

class iCloudNotifier {
    
    func send(_ thiefDto: ThiefDto) -> Bool {
        guard let localURL = thiefDto.filepath else {
            assert(false, "wrong file path")
            return false
        }
        
        guard var iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
            assert(false, "Wrong urls")
            return false
        }
        
        iCloudURL.appendPathComponent(localURL.lastPathComponent)
        
        var image = thiefDto.snapshot
        let info = thiefDto.info()
        if info.isEmpty == false {
            image = image?.imageWithText(text: info)
        }
        
        do {
            let data = image?.jpegData
            try data?.write(to: iCloudURL)
        } catch {
            print(error)
        }
        
        return true
    }
}
