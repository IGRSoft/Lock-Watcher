//
//  DatabaseDtoList.swift
//  Lock-Watcher
//
//  Created by Vitalii P on 05.07.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import Foundation

/// List of dtos in database
class DatabaseDtoList: Codable, ObservableObject {
    
    enum CodingKeys: String, CodingKey {
        case dtos
    }
    
    @Published var dtos: [DatabaseDto]
    
    init(dtos: [DatabaseDto]) {
        self.dtos = dtos
    }
    
    func append(_ dto: DatabaseDto) {
        dtos.append(dto)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dtos, forKey: .dtos)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        dtos = try container.decode([DatabaseDto].self, forKey: .dtos)
    }
}

extension DatabaseDtoList {
    static var empty: DatabaseDtoList {
        DatabaseDtoList(dtos: [])
    }
}
