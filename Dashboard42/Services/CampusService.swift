//
//  CampusService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import Foundation

@Observable
final class CampusService {
    private(set) var events: [Event] = []
    private(set) var exams: [Exam] = []
    
    private let network: NetworkingManager = .shared
    
    init() {
    }
    
    func fetchEvents(campusId: Int, cursusId: Int) async throws -> Void {
        let endpoint: NetworkingEndpoint = CampusEndpoints.fetchEvents(campusId: campusId, cursusId: cursusId)
        
        self.events = try await network.request(endpoint, type: [Event].self)
    }
    
    func fetchExams(campusId: Int) async throws -> Void {
        let endpoint: NetworkingEndpoint = CampusEndpoints.fetchExams(campusId: campusId)
        
        self.exams = try await network.request(endpoint, type: [Exam].self)
    }
}
