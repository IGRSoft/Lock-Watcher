//
//  Date+IGRExtension.swift
//  Date+IGRExtension
//
//  Created by Vitalii Parovishnyk on 03.09.2021.
//

import Foundation

extension Date {
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
