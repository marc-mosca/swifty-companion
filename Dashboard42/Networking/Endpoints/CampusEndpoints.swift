//
//  CampusEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import Foundation

enum CampusEndpoints: NetworkingEndpoint {
    case fetchEvents(campusId: Int, cursusId: Int)
    case fetchExams(campusId: Int)
    
    var path: String {
        switch self {
        case .fetchEvents(let campusId, let cursusId): "/v2/campus/\(campusId)/cursus/\(cursusId)/events"
        case .fetchExams(let campusId): "/v2/campus/\(campusId)/exams"
        }
    }
    
    var method: NetworkingManager.HTTPMethod { .GET }
    
    var token: AuthenticationToken? {
        switch self {
        case .fetchEvents: .user
        case .fetchExams: .application
        }
    }
    
    var queryItems: [URLQueryItem]? {
        let items: [String: String]
        
        switch self {
        case .fetchEvents: items = ["filter[future]": "true", "sort": "begin_at", "page[size]": "100"]
        case .fetchExams: items = ["filter[future]": "true", "sort": "-begin_at"]
        }
        
        return items.map { .init(name: $0.key, value: $0.value) }
    }
}
