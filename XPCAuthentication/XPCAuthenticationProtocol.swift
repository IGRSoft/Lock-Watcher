//
//  XPCAuthenticationProtocol.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.03.2021.
//

import Foundation

@objc
public protocol XPCAuthenticationProtocol {
    func detectedAuthenticationFailedFromDate(_ date: Date, _ replyBlock: @escaping (Bool) -> Void)
}
