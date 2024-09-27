//
//  CampusService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import Foundation

@Observable
final class CampusService {
    private(set) var events = [Event]()
    private(set) var exams = [Exam]()
    
    private(set) var isLoading = false
    private(set) var isFirstLoad = true
    
    init() { }
    
    func loadCampusActivities(campusId: Int, cursusId: Int) async throws {
        guard isFirstLoad else { return }
        
        isFirstLoad = false
        isLoading = true
        
        events = try await NetworkingManager.shared.request(CampusEndpoints.fetchEvents(campusId: campusId, cursusId: cursusId), type: [Event].self)
        exams = try await NetworkingManager.shared.request(CampusEndpoints.fetchExams(campusId: campusId), type: [Exam].self)
        
        isLoading = false
    }
    
    func refreshCampusActivities(campusId: Int, cursusId: Int) async throws {
        isFirstLoad = true
        try await loadCampusActivities(campusId: campusId, cursusId: cursusId)
    }
}
