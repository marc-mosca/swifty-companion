//
//  Slot.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 04/10/2024.
//

import Foundation

struct GroupedSlot: Identifiable {
    var id: UUID { .init() }
    
    var beginAt: Date
    var endAt: Date
    var slots: [Slot]
    var slotsIds: [Int]
    
    static func create(for slots: [Slot]) -> [GroupedSlot] {
        let sortedSlots: [Slot] = slots.sorted { $0.beginAt < $1.beginAt }
        var groupedSlots: [GroupedSlot] = []
        
        sortedSlots.forEach { slot in
            if groupedSlots.isEmpty == true || groupedSlots.last!.endAt != slot.beginAt {
                let newGroupedSlot: GroupedSlot = .init(
                    beginAt: slot.beginAt,
                    endAt: slot.endAt,
                    slots: [slot],
                    slotsIds: [slot.id]
                )
                groupedSlots.append(newGroupedSlot)
            }
            else {
                let count: Int = groupedSlots.count - 1
                groupedSlots[count].slots.append(slot)
                groupedSlots[count].slotsIds.append(slot.id)
                groupedSlots[count].endAt = slot.endAt
            }
        }
        
        return groupedSlots
    }
}

struct Slot: Identifiable, Decodable {
    let id: Int
    let beginAt: Date
    let endAt: Date
    let scaleTeam: [ScaleTeam]?
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case beginAt = "begin_at"
        case endAt = "end_at"
        case scaleTeam = "scale_team"
        case user = "user"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.beginAt = try container.decode(Date.self, forKey: .beginAt)
        self.endAt = try container.decode(Date.self, forKey: .endAt)
        self.scaleTeam = try container.decodeIfPresent([ScaleTeam].self, forKey: .scaleTeam)
        self.user = try container.decode(Slot.User.self, forKey: .user)
    }
}

extension Slot {
    enum TeamType: Decodable {
        case string(String)
        case team([ScaleTeam])
    }
    
    struct User: Identifiable, Decodable {
        let id: Int
        let login: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case login = "login"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.login = try container.decode(String.self, forKey: .login)
        }
    }
    
    struct ScaleTeam: Identifiable, Decodable {
        let id: Int
        let scaleId: Int
        let beginAt: Date
        let correcteds: [Slot.User]
        let corrector: Slot.User
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case scaleId = "scale_id"
            case beginAt = "begin_at"
            case correcteds = "correcteds"
            case corrector = "corrector"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decode(Int.self, forKey: .id)
            self.scaleId = try container.decode(Int.self, forKey: .scaleId)
            self.beginAt = try container.decode(Date.self, forKey: .beginAt)
            self.correcteds = try container.decode([Slot.User].self, forKey: .correcteds)
            self.corrector = try container.decode(Slot.User.self, forKey: .corrector)
        }
    }
}
