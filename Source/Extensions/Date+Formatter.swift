//
//  Date+IGRExtension.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 03.09.2021.
//

import Foundation

extension Date {
    
    /// Default formatter for date in application
    /// 
    static let defaultFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }()
}
