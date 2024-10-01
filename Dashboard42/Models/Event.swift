//
//  Event.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import Foundation

struct EventUser: Identifiable, Decodable {
    let id: Int
    let eventId: Int
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case eventId = "event_id"
        case userId = "user_id"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.eventId = try container.decode(Int.self, forKey: .eventId)
        self.userId = try container.decode(Int.self, forKey: .userId)
    }
}

struct Event: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String
    let location: String
    let kind: String
    let maxPeople: Int?
    let nbrSubscribers: Int
    let beginAt: Date
    let endAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case location = "location"
        case kind = "kind"
        case maxPeople = "max_people"
        case nbrSubscribers = "nbr_subscribers"
        case beginAt = "begin_at"
        case endAt = "end_at"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.location = try container.decode(String.self, forKey: .location)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.maxPeople = try container.decodeIfPresent(Int.self, forKey: .maxPeople)
        self.nbrSubscribers = try container.decode(Int.self, forKey: .nbrSubscribers)
        self.beginAt = try container.decode(Date.self, forKey: .beginAt)
        self.endAt = try container.decode(Date.self, forKey: .endAt)
    }
}
