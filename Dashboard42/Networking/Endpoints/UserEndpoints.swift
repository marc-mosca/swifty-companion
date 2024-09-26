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
    
    var path: String {
        switch self {
        case .fetchMe: "/v2/me"
        case .fetchUser(let login): "/v2/users/\(login)"
        }
    }
    
    var method: NetworkingManager.HTTPMethod { .GET }
    var token: AuthenticationToken? { .user }
    var queryItems: [URLQueryItem]? { nil }
}
