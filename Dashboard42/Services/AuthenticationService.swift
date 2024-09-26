//
//  AuthenticationService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 17/09/2024.
//

import Foundation

@Observable
class AuthenticationService {
    private(set) var userTokens: AuthenticationUserToken?
    private(set) var applicationTokens: AuthenticationApplicationToken?
    
    var authenticationURL: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.intra.42.fr"
        urlComponents.path = "/oauth/authorize"
        
        var queryItems = [URLQueryItem]()
        queryItems.append(.init(name: "client_id", value: Constants.clientID))
        queryItems.append(.init(name: "redirect_uri", value: Constants.redirectURI))
        queryItems.append(.init(name: "response_type", value: "code"))
        queryItems.append(.init(name: "scope", value: "public+projects+profile"))
        
        urlComponents.queryItems = queryItems
        
        return urlComponents.url
    }
    
    init() { }
    
    func signIn(url: URL) async throws {
        let code = try fetchCodeInURL(url)
        userTokens = try await NetworkingManager.shared.request(AuthenticationEndpoints.userTokens(code: code), type: AuthenticationUserToken.self)
        applicationTokens = try await NetworkingManager.shared.request(AuthenticationEndpoints.applicationTokens, type: AuthenticationApplicationToken.self)
        try KeychainManager.shared.save(account: .applicationAccessToken, data: applicationTokens?.accessToken ?? "")
        try KeychainManager.shared.save(account: .userAccessToken, data: userTokens?.accessToken ?? "")
        try KeychainManager.shared.save(account: .userRefreshToken, data: userTokens?.refreshToken ?? "")
    }
}

extension AuthenticationService {
    
    private func fetchCodeInURL(_ url: URL) throws -> String {
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems
        
        if let code = queryItems?.first(where: { $0.name == "code" })?.value {
            return code
        }
        
        throw Dashboard42Errors.runtimeError("Can't find code in URL")
    }
}
