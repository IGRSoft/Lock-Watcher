//
//  NotifierProtocol.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 05.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

protocol NotifierProtocol {
    func register(with settings: any AppSettingsProtocol)
    
    func send(_ thiefDto: ThiefDto) -> Bool
}
