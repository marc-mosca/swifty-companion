//
//  UserEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 26/09/2024.
//

import Foundation

enum UserEndpoints: NetworkingEndpoint {
    case fetchMe
    case fetchUser(login: String)
    case fetchEvents(userId: Int)
    case fetchExams(userId: Int)
    case fetchScales
    case fetchSlots
    case fetchCorrectionPointHistorics(userId: Int)
    case fetchLogtime(login: String, entryDate: String)
    case fetchEventUser(userId: Int, eventId: Int)
    case registerEvent(userId: Int, eventId: Int)
    case unregisterEvent(eventUserId: Int)
    case registerSlot(userId: Int, beginAt: Date, endAt: Date)
    case unregisterSlot(slotId: Int)
    
    var path: String {
        switch self {
        case .fetchMe: return "/v2/me"
        case .fetchUser(let login): return "/v2/users/\(login)"
        case .fetchEvents(let userId): return "/v2/users/\(userId)/events"
        case .fetchExams(let userId): return "/v2/users/\(userId)/exams"
        case .fetchScales: return "/v2/me/scale_teams"
        case .fetchSlots: return "/v2/me/slots"
        case .fetchCorrectionPointHistorics(let userId): return "/v2/users/\(userId)/correction_point_historics"
        case .fetchLogtime(let login, _): return "/v2/users/\(login)/locations_stats"
        case .fetchEventUser(let userId, _): return "/v2/users/\(userId)/events_users"
        case .registerEvent: return "/v2/events_users"
        case .unregisterEvent(let eventUserId): return "/v2/events_users/\(eventUserId)"
        case .registerSlot: return "/v2/slots"
        case .unregisterSlot(let slotId): return "/v2/slots/\(slotId)"
        }
    }
    
    var method: NetworkingManager.HTTPMethod {
        switch self {
        case .registerEvent, .registerSlot: return .POST
        case .unregisterEvent, .unregisterSlot: return .DELETE
        default: return .GET
        }
    }
    
    var token: AuthenticationToken? {
        switch self {
        case .fetchExams, .fetchLogtime: return .application
        default: return .user
        }
    }
    
    var queryItems: [URLQueryItem]? {
        let items: [String: String]
        
        switch self {
        case .fetchEvents: items = ["sort": "-begin_at", "page[size]": "100"]
        case .fetchExams: items = ["filter[future]": "true", "sort": "-begin_at"]
        case .fetchScales: items = ["sort": "-begin_at", "page[size]": "100"]
        case .fetchSlots: items = ["filter[future]": "true", "sort": "-begin_at", "page[size]": "100"]
        case .fetchCorrectionPointHistorics: items = ["sort": "-created_at"]
        case .fetchLogtime(_, let entryDate): items = ["begin_at": entryDate]
        case .fetchEventUser(_, let eventId): items = ["filter[event_id]": "\(eventId)"]
        case .registerEvent(let userId, let eventId): items = ["events_user[event_id]": "\(eventId)", "events_user[user_id]": "\(userId)"]
        case .registerSlot(let userId, let beginAt, let endAt): items = ["slot[user_id]": "\(userId)", "slot[begin_at]": "\(beginAt)", "slot[end_at]": "\(endAt)"]
        default: return nil
        }
        
        return items.map { .init(name: $0.key, value: $0.value) }
    }
}
