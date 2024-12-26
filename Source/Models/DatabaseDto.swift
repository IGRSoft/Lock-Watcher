//
//  DatabaseDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.08.2021.
//

import Foundation

/// Represents a data object that is suitable for database storage.
/// This is created by transforming the `ThiefDto` into a storable format.
///
public final class DatabaseDto: Codable, Identifiable {
    
    /// Enumerates the keys used in the encoding and decoding processes.
    ///
    enum CodingKeys: String, CodingKey {
        case date, data, path
    }
    
    /// The date the object was created or the event was captured.
    var date: Date
    
    /// The raw data, likely representing an image or snapshot from `ThiefDto`.
    var data: Data
    
    /// The optional path where additional data or files might be stored.
    var path: URL?
    
    /// Encodes the object's properties into the encoder.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(date, forKey: .date)
        try container.encode(data, forKey: .data)
        try container.encodeIfPresent(path, forKey: .path)
    }
    
    /// Initializes the object by decoding from the provided decoder.
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(Date.self, forKey: .date)
        data = try container.decode(Data.self, forKey: .data)
        path = try container.decodeIfPresent(URL.self, forKey: .path)
    }
    
    /// Initializes the `DatabaseDto` using a `ThiefDto` object.
    ///
    /// - Parameter thiefDto: The `ThiefDto` object that provides the data.
    init(with thiefDto: ThiefDto) {
        date = thiefDto.date
        data = thiefDto.snapshot!.jpegData
        path = thiefDto.filePath
    }
}

extension DatabaseDto: Equatable, Hashable {
    /// Checks the equality between two `DatabaseDto` objects.
    public static func == (lhs: DatabaseDto, rhs: DatabaseDto) -> Bool {
        return lhs.date == rhs.date &&
        lhs.data == rhs.data &&
        lhs.path == rhs.path
    }
    
    /// Checks if one `DatabaseDto` is older than the other based on the date.
    public static func < (lhs: DatabaseDto, rhs: DatabaseDto) -> Bool {
        return lhs.date < rhs.date
    }
    
    /// Generates a hash value for the object.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(date)
        hasher.combine(data)
    }
}
