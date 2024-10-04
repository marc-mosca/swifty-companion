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
        self.logtimes = self.convertLogtimes(log)
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

extension UserService {
    private func convertLogtimes(_ result: LogtimeResult) -> [Logtime] {
        var monthData: [Logtime] = []
        var monthlyData: [String: Double] = [:]
        
        for (date, time) in result {
            let components: [String.SubSequence] = date.split(separator: "-")
            let yearMonth: String = "\(components[0])-\(components[1])"
            let timeComponents: [String] = time.components(separatedBy: ":")
            let hours: Double = Double(timeComponents[0]) ?? 0.0
            let minutes: Double = Double(timeComponents[1]) ?? 0.0
            let seconds: Double = Double(timeComponents[2].components(separatedBy: ".").first ?? "0.0") ?? 0.0
            
            let totalHours: Double = hours + minutes / 60.0 + seconds / 3600.0
            monthlyData[yearMonth, default: 0.0] += totalHours
        }
        
        monthData = monthlyData.map { month, totalHours in
            let logtime: LogtimeResult = result.filter { $0.key.contains(month) }
            let numberOfDaysToWork = Date.getNumberOfDaysToWorkPerMonth(month)
            
            return Logtime(
                month: month,
                total: totalHours,
                details: logtime,
                numberOfDaysToWork: numberOfDaysToWork
            )
        }
        
        monthData.sort(by: { $0.month > $1.month })
        return monthData
    }
}
