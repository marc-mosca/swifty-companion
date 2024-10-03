//
//  NetworkingManager.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import Foundation
import OSLog

actor NetworkingManager {
    static let shared: NetworkingManager = .init()
    
    private let session: URLSession = .shared
    private let decoder: JSONDecoder = .init()
    private let logger: Logger = .init(subsystem: "fr.marcmosca.Dashboard42", category: "Networking")
    private let keychain: KeychainService = .shared
    
    enum HTTPMethod: String { case GET, POST, PUT, DELETE }
    
    private init() {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        
        decoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    func request(_ endpoint: NetworkingEndpoint) async throws -> Void {
        let urlRequest: URLRequest = try self.buildRequest(endpoint)
        let (_, response): (Data, URLResponse) = try await self.session.data(for: urlRequest)
        
        do {
            try self.handleHTTPResponse(response)
            self.logger.log("🟢 \(endpoint.path) - Request succeeded.")
        }
        catch Dashboard42Errors.invalidAccessToken {
            self.logger.error("🔴 \(endpoint.path) - Request failed due to an invalid access token.")
            try await self.handleInvalidAccessToken(token: endpoint.token)
            try await self.request(endpoint)
        }
        catch Dashboard42Errors.tooManyRequests {
            self.logger.error("🔴 \(endpoint.path) - Request failed due to too many requests.")
            try await self.handleTooManyRequests()
            try await self.request(endpoint)
        }
        catch Dashboard42Errors.serverError {
            self.logger.error("🔴 \(endpoint.path) - Request failed due to a server error.")
            throw Dashboard42Errors.serverError
        }
        catch {
            self.logger.error("🔴 \(endpoint.path) - Request failed due to a decoding error.")
            throw Dashboard42Errors.decodingError
        }
    }
    
    func request<T: Decodable>(_ endpoint: NetworkingEndpoint, type: T.Type) async throws -> T {
        let urlRequest: URLRequest = try self.buildRequest(endpoint)
        let (data, response): (Data, URLResponse) = try await self.session.data(for: urlRequest)
        
        do {
            try self.handleHTTPResponse(response)
            let result: T = try decoder.decode(T.self, from: data)
            logger.log("🟢 \(endpoint.path) - Request succeeded.")
            return result
        }
        catch Dashboard42Errors.invalidAccessToken {
            self.logger.error("🔴 \(endpoint.path) - Request failed due to an invalid access token.")
            try await self.handleInvalidAccessToken(token: endpoint.token)
            return try await self.request(endpoint, type: type)
        }
        catch Dashboard42Errors.tooManyRequests {
            self.logger.error("🔴 \(endpoint.path) - Request failed due to too many requests.")
            try await self.handleTooManyRequests()
            return try await self.request(endpoint, type: type)
        }
        catch Dashboard42Errors.serverError {
            self.logger.error("🔴 \(endpoint.path) - Request failed due to a server error.")
            throw Dashboard42Errors.serverError
        }
        catch {
            self.logger.error("🔴 \(endpoint.path) - Request failed due to a decoding error.")
            throw Dashboard42Errors.decodingError
        }
    }
}

extension NetworkingManager {
    private func buildRequest(_ endpoint: NetworkingEndpoint) throws -> URLRequest {
        var components: URLComponents = .init()
        components.scheme = "https"
        components.host = "api.intra.42.fr"
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url: URL = components.url else { throw Dashboard42Errors.runtimeError("Cannot build URL from components") }
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        var accessToken: String
        
        if endpoint.token == .application {
            accessToken = keychain.get(account: .applicationAccessToken) ?? ""
        }
        else {
            accessToken = keychain.get(account: .userAccessToken) ?? ""
        }
        
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleHTTPResponse(_ response: URLResponse) throws -> Void {
        guard let response: HTTPURLResponse = response as? HTTPURLResponse else {
            throw Dashboard42Errors.runtimeError("Cannot cast response to HTTPURLResponse")
        }
        
        switch response.statusCode {
        case (200 ..< 300): return
        case 401: throw Dashboard42Errors.invalidAccessToken
        case 429: throw Dashboard42Errors.tooManyRequests
        default: throw Dashboard42Errors.serverError
        }
    }
    
    private func handleInvalidAccessToken(token: AuthenticationToken?) async throws -> Void {
        if token == .application {
            let newToken = try await request(AuthenticationEndpoints.applicationTokens, type: AuthenticationApplicationToken.self)
            try? keychain.save(account: .applicationAccessToken, data: newToken.accessToken)
        }
        else {
            guard let refreshToken = keychain.get(account: .userRefreshToken) else { throw Dashboard42Errors.invalidAccessToken }
            
            let newToken = try await request(AuthenticationEndpoints.refreshUserTokens(refreshToken: refreshToken), type: AuthenticationUserToken.self)
            try? keychain.save(account: .userAccessToken, data: newToken.accessToken)
            try? keychain.save(account: .userRefreshToken, data: newToken.refreshToken)
        }
    }
    
    private func handleTooManyRequests() async throws -> Void {
        try await Task.sleep(for: .seconds(1))
    }
}
