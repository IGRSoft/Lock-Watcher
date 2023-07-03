//
//  String+Regex.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 28.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation

extension String {
    
    /// match regular expression in text
    /// returns array of strings
    /// 
    func matches(for regex: String) -> [String]? {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            return results.map { nsString.substring(with: $0.range(at: 1))}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            
            return nil
        }
    }
}
