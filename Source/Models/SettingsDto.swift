//
//  SettingsDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation
import SwiftyDropbox

class SettingsDto: ObservableObject, Codable {
    static let kSettingsDtoKey = "Settings"
    
    enum CodingKeys: String, CodingKey {
        case isFirstLaunch
        
        case isUseSnapshotOnWakeUp
        case isUseSnapshotOnWrongPassword
        case isUseSnapshotOnSwitchToBatteryPower
        case isUseSnapshotOnUSBMount
        
        case isSendNotificationToMail
        case mailRecipient
        
        case isICloudSyncEnable
        
        case isDropboxEnable
        case dropboxName
    }
    
    @Published var isFirstLaunch: Bool = false 
    
    @Published var isUseSnapshotOnWakeUp: Bool = false
    @Published var isUseSnapshotOnWrongPassword: Bool = false
    @Published var isUseSnapshotOnSwitchToBatteryPower: Bool = false
    @Published var isUseSnapshotOnUSBMount: Bool = false
    
    @Published var isSendNotificationToMail: Bool = false
    @Published var mailRecipient: String = ""
    
    @Published var isICloudSyncEnable: Bool = false
    
    @Published var isDropboxEnable: Bool = false
    @Published var dropboxName: String = ""
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isFirstLaunch, forKey: .isFirstLaunch)
        
        try container.encode(isUseSnapshotOnWakeUp, forKey: .isUseSnapshotOnWakeUp)
        try container.encode(isUseSnapshotOnWrongPassword, forKey: .isUseSnapshotOnWrongPassword)
        try container.encode(isUseSnapshotOnSwitchToBatteryPower, forKey: .isUseSnapshotOnSwitchToBatteryPower)
        try container.encode(isUseSnapshotOnUSBMount, forKey: .isUseSnapshotOnUSBMount)
        
        try container.encode(isSendNotificationToMail, forKey: .isSendNotificationToMail)
        try container.encode(mailRecipient, forKey: .mailRecipient)
        
        try container.encode(isICloudSyncEnable, forKey: .isICloudSyncEnable)
        
        try container.encode(isDropboxEnable, forKey: .isDropboxEnable)
        try container.encode(dropboxName, forKey: .dropboxName)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        isFirstLaunch = try container.decode(Bool.self, forKey: .isFirstLaunch)
        
        isUseSnapshotOnWakeUp = try container.decode(Bool.self, forKey: .isUseSnapshotOnWakeUp)
        isUseSnapshotOnWrongPassword = try container.decode(Bool.self, forKey: .isUseSnapshotOnWrongPassword)
        isUseSnapshotOnSwitchToBatteryPower = try container.decode(Bool.self, forKey: .isUseSnapshotOnSwitchToBatteryPower)
        isUseSnapshotOnUSBMount = try container.decode(Bool.self, forKey: .isUseSnapshotOnUSBMount)
        
        isSendNotificationToMail = try container.decode(Bool.self, forKey: .isSendNotificationToMail)
        mailRecipient = try container.decode(String.self, forKey: .mailRecipient)
        
        isICloudSyncEnable = try container.decode(Bool.self, forKey: .isICloudSyncEnable)
        
        isDropboxEnable = try container.decode(Bool.self, forKey: .isDropboxEnable)
        dropboxName = try container.decode(String.self, forKey: .dropboxName)
    }
    
    init() {}
    
    static func current() -> SettingsDto {
        if let savedSettings = UserDefaults.standard.object(forKey: kSettingsDtoKey) as? Data {
            let decoder = JSONDecoder()
            do {
                let settings = try decoder.decode(SettingsDto.self, from: savedSettings)
                return settings
            } catch {
                print(error)
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
