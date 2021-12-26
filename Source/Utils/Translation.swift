//
//  Translation.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 26.12.2021.
//

import Foundation

enum Translation {
    static func keep(last: Int) -> String {
        return String(format: NSLocalizedString("KeepLastN", comment: ""), arguments: [last])
    }
    static func synkedDropbox(name: String) -> String {
        return String(format: NSLocalizedString("SyncedWithDropbox", comment: ""), arguments: [name])
    }
}
