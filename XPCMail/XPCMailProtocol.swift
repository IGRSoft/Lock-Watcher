//
//  XPCMailProtocol.swift
//  XPCMail
//
//  Created by Vitalii Parovishnyk on 09.01.2021.
//

import AppKit
import Foundation
import CoreLocation

@objc
public protocol XPCMailProtocol {
    @objc func sendMail(_ to: String, coordinates: CLLocationCoordinate2D, attachment: String)
}
