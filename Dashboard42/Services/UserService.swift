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
    
    private(set) var isLoading = false
    
    init() { }
    
    func loadUserInformations() async throws {
        isLoading = true
        
        let userResult = try await NetworkingManager.shared.request(UserEndpoints.fetchMe, type: User.self)
        
        user = userResult
        events = try await NetworkingManager.shared.request(UserEndpoints.fetchEvents(userId: userResult.id), type: [Event].self)
        exams = try await NetworkingManager.shared.request(UserEndpoints.fetchExams(userId: userResult.id), type: [Exam].self)
        scales = try await NetworkingManager.shared.request(UserEndpoints.fetchScales, type: [Scale].self)
        
        isLoading = false
    }
    
    func registerEvent(userId: Int, eventId: Int) async throws {
        try await NetworkingManager.shared.request(UserEndpoints.registerEvent(userId: userId, eventId: eventId))
        events = try await NetworkingManager.shared.request(UserEndpoints.fetchEvents(userId: userId), type: [Event].self)
    }
    
    func unregisterEvent(userId: Int, eventId: Int) async throws {
        let eventUser = try await NetworkingManager.shared.request(UserEndpoints.fetchEventUser(userId: userId, eventId: eventId), type: [EventUser].self)
        
        guard let eventUserId = eventUser.first?.id else { return }
        
        try await NetworkingManager.shared.request(UserEndpoints.unregisterEvent(eventUserId: eventUserId))
        events = try await NetworkingManager.shared.request(UserEndpoints.fetchEvents(userId: userId), type: [Event].self)
    }
}
