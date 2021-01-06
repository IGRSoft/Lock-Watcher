//
//  SettingsDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

struct SettingsDto: Codable {
    enum CodingKeys: String, CodingKey {
            case isPowerListeningEnable
        }
    
    var isPowerListeningEnable = true
}
