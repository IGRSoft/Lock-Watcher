//
//  SettingsDomain.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct SettingsDomain: DomainViewConstant {
    var name: String = "SettingsDomain"
    
    var window: CGRect = .init(origin: .zero, size: .init(width: 420, height: CGFloat.infinity))
    
    var border: EdgeInsets = .init(top: 10, leading: 16, bottom: 10, trailing: 16)
}
