//
//  ViewProtocols.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 03.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

// add constants to view

protocol DomainViewConstant {
    var name: String { get }
    
    var window: CGRect { get set }
    var border: EdgeInsets { get set }
}

protocol DomainViewConstantProtocol {
    associatedtype DomainViewConstant
    
    var viewSettings: DomainViewConstant { get }
}

enum ViewConstants {
    static let spacing: CGFloat = 8
}
