//
//  FirstLaunchDomain.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 04.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

struct FirstLaunchDomain: DomainViewConstant {
    var name: String = "FirstLaunchDomain"
    
    var window: CGRect = .init(origin: .zero, size: .init(width: 320, height: 220))
    
    var border: EdgeInsets = .init(top: 10, leading: 16, bottom: 10, trailing: 16)
}
