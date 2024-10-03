//
//  UserService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 26/09/2024.
//

import Foundation

@Observable
final class UserService {
    private(set) var user: User? = nil
    private(set) var events: [Event] = []
    private(set) var exams: [Exam] = []
    private(set) var scales: [Scale] = []
    
    private let network: NetworkingManager = .shared
    
    init() {
    }
    
    func fetchConnectedUser() async throws -> Void {
        self.user = try await network.request(UserEndpoints.fetchMe, type: User.self)
    }
    
    func fetchUser(login: String) async throws -> User {
        let endpoint: NetworkingEndpoint = UserEndpoints.fetchUser(login: login)
        
        return try await network.request(endpoint, type: User.self)
    }
    
    func fetchEvents(userId: Int) async throws -> Void {
        let endpoint: NetworkingEndpoint = UserEndpoints.fetchEvents(userId: userId)
        
        self.events = try await network.request(endpoint, type: [Event].self)
    }
    
    func fetchExams(userId: Int) async throws -> Void {
        let endpoint: NetworkingEndpoint = UserEndpoints.fetchExams(userId: userId)
        
        self.exams = try await network.request(endpoint, type: [Exam].self)
    }
    
    func fetchScales() async throws -> Void {
        let endpoint: NetworkingEndpoint = UserEndpoints.fetchScales
        
        self.scales = try await network.request(endpoint, type: [Scale].self)
    }
    
    func updateEvent(userId: Int, eventId: Int) async throws -> Void {
        var endpoint: NetworkingEndpoint
        
        endpoint = UserEndpoints.registerEvent(userId: userId, eventId: eventId)
        try await network.request(endpoint)
        
        endpoint = UserEndpoints.fetchEvents(userId: userId)
        self.events = try await network.request(endpoint, type: [Event].self)
    }
    
    func deleteEvent(userId: Int, eventId: Int) async throws -> Void {
        var endpoint: NetworkingEndpoint
        
        endpoint = UserEndpoints.fetchEventUser(userId: userId, eventId: eventId)
        let eventUser: [EventUser] = try await network.request(endpoint, type: [EventUser].self)
        
        guard let eventUserId = eventUser.first?.id else { return }
        
        endpoint = UserEndpoints.unregisterEvent(eventUserId: eventUserId)
        try await network.request(endpoint)
        
        endpoint = UserEndpoints.fetchEvents(userId: userId)
        self.events = try await network.request(endpoint, type: [Event].self)
    }
}
