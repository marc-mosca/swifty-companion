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
    private(set) var events = [Event]()
    private(set) var exams = [Exam]()
    private(set) var scales = [Scale]()
    
    init() { }
    
    func loadUser() async throws {
        let userResult = try await NetworkingManager.shared.request(UserEndpoints.fetchMe, type: User.self)
        
        user = userResult
        events = try await NetworkingManager.shared.request(UserEndpoints.fetchEvents(userId: userResult.id), type: [Event].self)
        exams = try await NetworkingManager.shared.request(UserEndpoints.fetchExams(userId: userResult.id), type: [Exam].self)
        scales = try await NetworkingManager.shared.request(UserEndpoints.fetchScales, type: [Scale].self)
    }
}
