//
//  XPCMailProtocol.swift
//
//  Created on 28.03.2021.
//  Copyright © 2026 IGR Soft. All rights reserved.
//

import AppKit
import CoreLocation
import Foundation

@objc
public protocol XPCMailProtocol {
    @objc
    func sendMail(_ to: String, coordinates: CLLocationCoordinate2D, attachment: String)
}
