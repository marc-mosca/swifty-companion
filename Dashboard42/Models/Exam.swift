//
//  Exam.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import Foundation

struct Exam: Identifiable, Decodable {
    let id: Int
    let beginAt: Date
    let endAt: Date
    let location: String
    let maxPeople: Int?
    let nbrSubscribers: Int
    let name: String
    let projects: [Exam.Projects]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case beginAt = "begin_at"
        case endAt = "end_at"
        case location = "location"
        case maxPeople = "max_people"
        case nbrSubscribers = "nbr_subscribers"
        case name = "name"
        case projects = "projects"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.beginAt = try container.decode(Date.self, forKey: .beginAt)
        self.endAt = try container.decode(Date.self, forKey: .endAt)
        self.location = try container.decode(String.self, forKey: .location)
        self.maxPeople = try container.decodeIfPresent(Int.self, forKey: .maxPeople)
        self.nbrSubscribers = try container.decode(Int.self, forKey: .nbrSubscribers)
        self.name = try container.decode(String.self, forKey: .name)
        self.projects = try container.decode([Exam.Projects].self, forKey: .projects)
    }
}

extension Exam {
    struct Projects: Decodable, Identifiable {
        let id: Int
        let name: String
        let slug: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case slug = "slug_name"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.name = try container.decode(String.self, forKey: .name)
            self.slug = try container.decode(String.self, forKey: .slug)
        }
    }
}
