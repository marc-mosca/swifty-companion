//
//  UserService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 26/09/2024.
//

import Foundation

@Observable
class UserService {
    private(set) var user: User?
    
    init() { }
    
    func loadUser() async throws {
        user = try await NetworkingManager.shared.request(UserEndpoints.fetchMe, type: User.self)
    }
}
