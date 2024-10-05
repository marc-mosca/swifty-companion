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
    private(set) var slots: [Slot] = []
    private(set) var correctionPointHistorics: [CorrectionPointHistorics] = []
    private(set) var logtimes: [Logtime] = []
    
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
    
    func fetchSlots() async throws -> Void {
        let endpoint: NetworkingEndpoint = UserEndpoints.fetchSlots
        
        self.slots = try await network.request(endpoint, type: [Slot].self)
    }
    
    func fetchCorrectionPointHistorics(userId: Int) async throws -> Void {
        let endpoint: NetworkingEndpoint = UserEndpoints.fetchCorrectionPointHistorics(userId: userId)
        
        self.correctionPointHistorics = try await network.request(endpoint, type: [CorrectionPointHistorics].self)
    }
    
    func fetchLogtimes(login: String, entryDate: String) async throws -> Void {
        let endpoint: NetworkingEndpoint = UserEndpoints.fetchLogtime(login: login, entryDate: entryDate)
        
        let log: LogtimeResult = try await network.request(endpoint, type: LogtimeResult.self)
        self.logtimes = Logtime.organize(log, entryDate: entryDate)
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
    
    func updateSlot(userId: Int, beginAt: Date, endAt: Date) async throws -> Void {
        let endpoint: NetworkingEndpoint = UserEndpoints.registerSlot(userId: userId, beginAt: beginAt, endAt: endAt)
        try await network.request(endpoint)
    }
    
    func deleteSlot(slotId: Int) async throws -> Void {
        let endpoint: NetworkingEndpoint = UserEndpoints.unregisterSlot(slotId: slotId)
        try await network.request(endpoint)
    }
}
