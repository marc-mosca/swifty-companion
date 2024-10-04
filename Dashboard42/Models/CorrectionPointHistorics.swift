//
//  CorrectionPointHistorics.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 04/10/2024.
//

import Foundation

struct CorrectionPointHistorics: Identifiable, Decodable {
    let id: Int
    let scaleTeamId: Int?
    let total: Int
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case scaleTeamId = "scale_team_id"
        case total = "total"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.scaleTeamId = try container.decodeIfPresent(Int.self, forKey: .scaleTeamId)
        self.total = try container.decode(Int.self, forKey: .total)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}
