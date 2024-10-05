//
//  AuthenticationEndpoints.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import Foundation

enum AuthenticationEndpoints: NetworkingEndpoint {
    case userTokens(code: String)
    case applicationTokens
    case refreshUserTokens(refreshToken: String)
    
    var path: String { return "/oauth/token" }
    var method: NetworkingManager.HTTPMethod { return .POST }
    var token: AuthenticationToken? { return nil }
    
    var queryItems: [URLQueryItem]? {
        let items: [String: String]
        
        switch self {
        case .userTokens(let code):
            items = [
                "grant_type": "authorization_code",
                "client_id": Constants.clientID,
                "client_secret": Constants.clientSecret,
                "code": code,
                "redirect_uri": Constants.redirectURI
            ]
        case .applicationTokens:
            items = [
                "grant_type": "client_credentials",
                "client_id": Constants.clientID,
                "client_secret": Constants.clientSecret,
                "scope": "public+projects+profile"
            ]
        case .refreshUserTokens(let refreshToken):
            items = [
                "grant_type": "refresh_token",
                "client_id": Constants.clientID,
                "client_secret": Constants.clientSecret,
                "refresh_token": refreshToken,
                "redirect_uri": Constants.redirectURI
            ]
        }
        
        return items.map { .init(name: $0.key, value: $0.value) }
    }
}
