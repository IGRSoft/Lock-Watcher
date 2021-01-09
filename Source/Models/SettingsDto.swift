//
//  SettingsDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

class SettingsDto: ObservableObject, Codable {
    static let kSettingsDtoKey = "Settings"
    
    enum CodingKeys: String, CodingKey {
        case isFirstLaunch
        case isUseSnapshotOnWakeUp
        case isUseSnapshotOnWrongPassword
        case isUseSnapshotOnSwitchToBatteryPower
    }
    
    @Published var isFirstLaunch: Bool = false {
        didSet {
            save()
        }
    }
    @Published var isUseSnapshotOnWakeUp: Bool = false {
        didSet {
            save()
        }
    }
    @Published var isUseSnapshotOnWrongPassword: Bool = false {
        didSet {
            save()
        }
    }
    @Published var isUseSnapshotOnSwitchToBatteryPower: Bool = false {
        didSet {
            save()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(isFirstLaunch, forKey: .isFirstLaunch)
        
        try container.encode(isUseSnapshotOnWakeUp, forKey: .isUseSnapshotOnWakeUp)
        try container.encode(isUseSnapshotOnWrongPassword, forKey: .isUseSnapshotOnWrongPassword)
        try container.encode(isUseSnapshotOnSwitchToBatteryPower, forKey: .isUseSnapshotOnSwitchToBatteryPower)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        isFirstLaunch = try container.decode(Bool.self, forKey: .isFirstLaunch)
        
        isUseSnapshotOnWakeUp = try container.decode(Bool.self, forKey: .isUseSnapshotOnWakeUp)
        isUseSnapshotOnWrongPassword = try container.decode(Bool.self, forKey: .isUseSnapshotOnWrongPassword)
        isUseSnapshotOnSwitchToBatteryPower = try container.decode(Bool.self, forKey: .isUseSnapshotOnSwitchToBatteryPower)
    }
    
    init() { }
    
    static func current() -> SettingsDto {
        if let savedSettings = UserDefaults.standard.object(forKey: kSettingsDtoKey) as? Data {
            let decoder = JSONDecoder()
            if let settings = try? decoder.decode(SettingsDto.self, from: savedSettings) {
                return settings
            }
        }
        
        let settings = SettingsDto()
        settings.save()
        
        return settings
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: SettingsDto.kSettingsDtoKey)
        }
    }
}
