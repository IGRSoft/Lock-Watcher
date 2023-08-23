//
//  String+Regex.swift
//  IGR Software
//
//  Created by Vitalii Parovishnyk on 28.01.2022.
//  Copyright © 2022 IGR Soft. All rights reserved.
//

import Foundation

extension String {
    
    /// Searches for all matches of a regular expression within the string.
    ///
    /// This method attempts to find all occurrences of the specified regular expression within the string. 
    /// Each matched string is added to the result array.
    ///
    /// - Parameters:
    ///   - regex: The regular expression pattern to search for.
    ///
    /// - Returns: An array of `String` that represent the matches. Returns `nil` if the regular expression is invalid or no match is found.
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
