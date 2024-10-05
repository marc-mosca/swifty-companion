//
//  NetworkingEndpoint.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import Foundation

protocol NetworkingEndpoint {
    var path: String { get }
    var method: NetworkingManager.HTTPMethod { get }
    var token: AuthenticationToken? { get }
    var queryItems: [URLQueryItem]? { get }
}
