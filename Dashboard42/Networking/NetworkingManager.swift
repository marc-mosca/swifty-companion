//
//  NetworkingManager.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import Foundation
import OSLog

actor NetworkingManager {
    static let shared = NetworkingManager()
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let logger = Logger(subsystem: "fr.marcmosca.Dashboard42", category: "Networking")
    
    enum HTTPMethod: String { case GET, POST, PUT, DELETE }
    
    private init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        
        decoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    func request(_ endpoint: NetworkingEndpoint) async throws {
        let urlRequest = try buildRequest(endpoint)
        let (_, response) = try await session.data(for: urlRequest)
        
        do {
            try handleHTTPResponse(response)
            logger.log("🟢 \(endpoint.path) - Request succeeded.")
        }
        catch Dashboard42Errors.invalidAccessToken {
            logger.error("🔴 \(endpoint.path) - Request failed due to an invalid access token.")
            try await handleInvalidAccessToken(token: endpoint.token)
            try await request(endpoint)
        }
        catch Dashboard42Errors.tooManyRequests {
            logger.error("🔴 \(endpoint.path) - Request failed due to too many requests.")
            try await handleTooManyRequests()
            try await request(endpoint)
        }
        catch Dashboard42Errors.serverError {
            logger.error("🔴 \(endpoint.path) - Request failed due to a server error.")
            throw Dashboard42Errors.serverError
        }
        catch {
            logger.error("🔴 \(endpoint.path) - Request failed due to a decoding error.")
            throw Dashboard42Errors.decodingError
        }
    }
    
    func request<T: Decodable>(_ endpoint: NetworkingEndpoint, type: T.Type) async throws -> T {
        let urlRequest = try buildRequest(endpoint)
        let (data, response) = try await session.data(for: urlRequest)
        
        do {
            try handleHTTPResponse(response)
            let result = try decoder.decode(T.self, from: data)
            logger.log("🟢 \(endpoint.path) - Request succeeded.")
            return result
        }
        catch Dashboard42Errors.invalidAccessToken {
            logger.error("🔴 \(endpoint.path) - Request failed due to an invalid access token.")
            try await handleInvalidAccessToken(token: endpoint.token)
            return try await request(endpoint, type: type)
        }
        catch Dashboard42Errors.tooManyRequests {
            logger.error("🔴 \(endpoint.path) - Request failed due to too many requests.")
            try await handleTooManyRequests()
            return try await request(endpoint, type: type)
        }
        catch Dashboard42Errors.serverError {
            logger.error("🔴 \(endpoint.path) - Request failed due to a server error.")
            throw Dashboard42Errors.serverError
        }
        catch {
            logger.error("🔴 \(endpoint.path) - Request failed due to a decoding error.")
            throw Dashboard42Errors.decodingError
        }
    }
}

extension NetworkingManager {
    
    private func buildRequest(_ endpoint: NetworkingEndpoint) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.intra.42.fr"
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else { throw Dashboard42Errors.runtimeError("Cannot build URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if endpoint.token == .application {
            let accessToken = KeychainService.shared.get(account: .applicationAccessToken)
            request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
        else if endpoint.token == .user {
            let accessToken = KeychainService.shared.get(account: .userAccessToken)
            request.addValue("Bearer \(accessToken ?? "")", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func handleHTTPResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw Dashboard42Errors.runtimeError("Cannot cast response to HTTPURLResponse")
        }
        
        if (200 ..< 300).contains(response.statusCode) {
            return
        }

        if response.statusCode == 401 {
            throw Dashboard42Errors.invalidAccessToken
        }
        else if response.statusCode == 429 {
            throw Dashboard42Errors.tooManyRequests
        }
        else {
            throw Dashboard42Errors.serverError
        }
    }
    
    private func handleInvalidAccessToken(token: AuthenticationToken?) async throws {
        if token == .application {
            let newToken = try await request(AuthenticationEndpoints.applicationTokens, type: AuthenticationApplicationToken.self)
            try? KeychainService.shared.save(account: .applicationAccessToken, data: newToken.accessToken)
        }
        else {
            guard let refreshToken = KeychainService.shared.get(account: .userRefreshToken) else { throw Dashboard42Errors.invalidAccessToken }

            let newToken = try await request(AuthenticationEndpoints.refreshUserTokens(refreshToken: refreshToken), type: AuthenticationUserToken.self)
            try? KeychainService.shared.save(account: .userAccessToken, data: newToken.accessToken)
            try? KeychainService.shared.save(account: .userRefreshToken, data: newToken.refreshToken)
        }
    }
    
    private func handleTooManyRequests() async throws {
        try await Task.sleep(for: .seconds(1))
    }
    
}
