//
//  AuthenticationToken.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 17/09/2024.
//

import Foundation

enum AuthenticationToken {
    case user
    case application
    
    var accessToken: String? {
        get {
            KeychainManager.shared.get(account: self == .application ? .applicationAccessToken : .userAccessToken)
        }
        set {
            let account = self == .application ? KeychainAccount.applicationAccessToken : KeychainAccount.userAccessToken

            if let newValue = newValue {
                try? KeychainManager.shared.save(account: account, data: newValue)
            }
            else {
                try? KeychainManager.shared.delete(account: account)
            }
        }
    }
    
    var refreshToken: String? {
        get {
            if self == .application { return nil }
            return KeychainManager.shared.get(account: .userRefreshToken)
        }
        set {
            if self == .application { return }

            if let newValue = newValue {
                try? KeychainManager.shared.save(account: .userRefreshToken, data: newValue)
            }
            else {
                try? KeychainManager.shared.delete(account: .userRefreshToken)
            }
        }
    }
}

struct AuthenticationUserToken: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case createdAt = "created_at"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
    }
}

struct AuthenticationApplicationToken: Decodable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
        case createdAt = "created_at"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        self.scope = try container.decode(String.self, forKey: .scope)
        self.createdAt = try container.decode(Int.self, forKey: .createdAt)
    }
}
