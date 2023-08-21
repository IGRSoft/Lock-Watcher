//
//  iCloudNotifier.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 10.08.2021.
//

import AppKit
import CoreLocation

final class iCloudNotifier: NotifierProtocol {
    
    //MARK: - Dependency injection
    
    private var logger: Log
    
    //MARK: - Variables
    
    private var documentsFolderName = "Documents"
    
    //MARK: - initialiser
    
    init(logger: Log = .init(category: .iCloudNotifier)) {
        self.logger = logger
    }
    
    //MARK: - public
    
    func register(with settings: any AppSettingsProtocol) {
    }
    
    func send(_ thiefDto: ThiefDto) -> Bool {
        guard let localURL = thiefDto.filePath else {
            let msg = "wrong file path"
            logger.error(msg)
            assert(false, msg)
            
            return false
        }
        
        guard var iCloudURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent(documentsFolderName) else {
            let msg = "wrong iCloud url"
            logger.error(msg)
            assert(false, msg)
            
            return false
        }
        
        iCloudURL.appendPathComponent(localURL.lastPathComponent)
        
        var image = thiefDto.snapshot
        let info = thiefDto.description()
        if info.isEmpty == false {
            image = image?.imageWithText(text: info)
        }
        
        logger.debug("send: \(thiefDto)")
        
        do {
            let data = image?.jpegData
            try data?.write(to: iCloudURL)
        } catch {
            logger.error(error.localizedDescription)
        }
        
        return true
    }
}
