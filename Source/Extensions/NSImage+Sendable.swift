//
//  NSImage+Sendable.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 17.12.2024.
//  Copyright © 2024 IGR Soft. All rights reserved.
//

import AppKit

extension NSImage: @retroactive @unchecked Sendable {}
