//
//  XPCPowerProtocol.swift
//  XPCPower
//
//  Created by Vitalii Parovishnyk on 06.01.2021.
//

import Foundation

@objc
public protocol XPCPowerProtocol {
    @objc func startCheckPower(_ replyBlock: @escaping (NSInteger) -> Void)
    @objc func stopCheckPower()
    @objc func updateReplay(_ replyBlock: @escaping (NSInteger) -> Void)
}
