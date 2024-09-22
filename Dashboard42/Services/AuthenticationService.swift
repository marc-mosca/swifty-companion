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
        userTokens = try await request(.fetchUserTokens(code: code))
        applicationTokens = try await request(.fetchApplicationTokens)
    }
}

extension AuthenticationService {
    
    private enum Endpoints {
        case fetchUserTokens(code: String)
        case fetchApplicationTokens
        case refreshUserTokens(refreshToken: String)
        
        var host: String { "api.intra.42.fr" }
        var path: String { return "/oauth/token" }
        var method: String { "POST" }
        
        var queryItems: [String: String] {
            switch self {
            case .fetchUserTokens(let code):
                [
                    "grant_type": "authorization_code",
                    "client_id": Constants.clientID,
                    "client_secret": Constants.clientSecret,
                    "code": code,
                    "redirect_uri": Constants.redirectURI,
                ]
            case .fetchApplicationTokens:
                [
                    "grant_type": "client_credentials",
                    "client_id": Constants.clientID,
                    "client_secret": Constants.clientSecret,
                    "scope": "public+projects+profile",
                ]
            case .refreshUserTokens(let refreshToken):
                [
                    "grant_type": "refresh_token",
                    "client_id": Constants.clientID,
                    "client_secret": Constants.clientSecret,
                    "refresh_token": refreshToken,
                    "redirect_uri": Constants.redirectURI,
                ]
            }
        }
        
        var url: URL? {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = host
            urlComponents.path = path
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            return urlComponents.url
        }
    }
    
    private func fetchCodeInURL(_ url: URL) throws -> String {
        let queryItems = URLComponents(string: url.absoluteString)?.queryItems
        
        if let code = queryItems?.first(where: { $0.name == "code" })?.value {
            return code
        }
        
        throw Dashboard42Errors.cannotFoundCodeInURL
    }
    
    private func request<T: Decodable>(_ endpoint: Endpoints) async throws -> T {
        guard let url = endpoint.url else { throw Dashboard42Errors.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        do {
            guard let response = response as? HTTPURLResponse else { throw Dashboard42Errors.invalidResponse }
            
            switch response.statusCode {
            case 200..<300:
                return try JSONDecoder().decode(T.self, from: data)
            default:
                throw Dashboard42Errors.runtimeError("Invalid response status code")
            }
        }
        catch let error {
            print(error)
            throw error
        }
    }
    
}
