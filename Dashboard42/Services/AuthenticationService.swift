//
//  AuthenticationService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 17/09/2024.
//

import Foundation

@Observable
class AuthenticationService {
    private(set) var userTokens: AuthenticationUserToken? = nil
    private(set) var applicationTokens: AuthenticationApplicationToken? = nil
    
    private let network: NetworkingManager = .shared
    private let keychain: KeychainService = .shared
    
    var authenticationURL: URL? {
        var urlComponents: URLComponents = .init()
        urlComponents.scheme = "https"
        urlComponents.host = "api.intra.42.fr"
        urlComponents.path = "/oauth/authorize"
        
        var queryItems: [URLQueryItem] = []
        queryItems.append(.init(name: "client_id", value: Constants.clientID))
        queryItems.append(.init(name: "redirect_uri", value: Constants.redirectURI))
        queryItems.append(.init(name: "response_type", value: "code"))
        queryItems.append(.init(name: "scope", value: "public+projects+profile"))
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    init() {
    }
    
    func fetchUserTokens(code: String) async throws -> Void {
        let endpoint: NetworkingEndpoint = AuthenticationEndpoints.userTokens(code: code)
        
        self.userTokens = try await network.request(endpoint, type: AuthenticationUserToken.self)
        try keychain.save(account: .userAccessToken, data: self.userTokens?.accessToken ?? "")
        try keychain.save(account: .userRefreshToken, data: self.userTokens?.refreshToken ?? "")
    }
    
    func fetchApplicationTokens() async throws -> Void {
        let endpoint: NetworkingEndpoint = AuthenticationEndpoints.applicationTokens
        
        self.applicationTokens = try await network.request(endpoint, type: AuthenticationApplicationToken.self)
        try keychain.save(account: .applicationAccessToken, data: self.applicationTokens?.accessToken ?? "")
    }
    
    func updateUserTokens(refreshToken: String) async throws -> Void {
        let endpoint: NetworkingEndpoint = AuthenticationEndpoints.refreshUserTokens(refreshToken: refreshToken)
        
        self.userTokens = try await network.request(endpoint, type: AuthenticationUserToken.self)
        try keychain.save(account: .userAccessToken, data: self.userTokens?.accessToken ?? "")
        try keychain.save(account: .userRefreshToken, data: self.userTokens?.refreshToken ?? "")
    }
    
    func signIn(url: URL) async throws -> Void {
        let queryItems: [URLQueryItem]? = URLComponents(string: url.absoluteString)?.queryItems
        
        guard let code: String = queryItems?.first(where: { $0.name == "code" })?.value else {
            throw Dashboard42Errors.runtimeError("Can't find code in URL")
        }
        
        try await self.fetchUserTokens(code: code)
        try await self.fetchApplicationTokens()
    }
}
