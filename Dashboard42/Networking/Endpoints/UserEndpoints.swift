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
    
    var path: String {
        switch self {
        case .fetchMe: "/v2/me"
        case .fetchUser(let login): "/v2/users/\(login)"
        case .fetchEvents(let userId): "/v2/users/\(userId)/events"
        case .fetchExams(let userId): "/v2/users/\(userId)/exams"
        case .fetchScales: "/v2/me/scale_teams"
        }
    }
    
    var method: NetworkingManager.HTTPMethod { .GET }
    
    var token: AuthenticationToken? {
        switch self {
        case .fetchExams: .application
        default: .user
        }
    }
    
    var queryItems: [URLQueryItem]? {
        let items: [String: String]
        
        switch self {
        case .fetchEvents: items = ["sort": "-begin_at", "page[size]": "100"]
        case .fetchExams: items = ["filter[future]": "true", "sort": "-begin_at"]
        case .fetchScales: items = ["sort": "-begin_at", "page[size]": "100"]
        default: return nil
        }
        
        return items.map { .init(name: $0.key, value: $0.value) }
    }
}
