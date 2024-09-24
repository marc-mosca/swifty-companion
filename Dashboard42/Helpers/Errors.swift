//
//  Errors.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 22/09/2024.
//

import Foundation

enum Dashboard42Errors: Error {
    case decodingError
    case invalidAccessToken
    case tooManyRequests
    case serverError
    
    case runtimeError(String)
}
