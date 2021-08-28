//
//  DatabaseDto.swift
//  Lock-Watcher
//
//  Created by Vitalii Parovishnyk on 28.08.2021.
//

import Foundation

class DatabaseDto: Codable {
    
    enum CodingKeys: String, CodingKey {
        case date, data, path
    }
    
    var date: Date?
    var data: Data?
    var path: URL?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(date, forKey: .date)
        try container.encode(data, forKey: .data)
        try container.encode(path, forKey: .path)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        date = try container.decode(Date.self, forKey: .date)
        data = try container.decode(Data.self, forKey: .data)
        path = try container.decode(URL.self, forKey: .path)
    }
    
    init(with thiefDto: ThiefDto) {
        date = thiefDto.date
        data = thiefDto.snapshot?.tiffRepresentation
        path = thiefDto.filepath
    }
}
