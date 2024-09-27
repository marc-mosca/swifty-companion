//
//  ActivitiesView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import SwiftUI

struct ActivitiesView: View {
    @Environment(CampusService.self) private var campusService
    @Environment(UserService.self) private var userService
    @State private var searchText = ""
    
    private var activities: [Activities] {
        let events = campusService.events.map { Activities.event($0) }
        let exams = campusService.exams.map { Activities.exam($0) }
        let homeActivities = events + exams
        
        return homeActivities.sorted(by: { $0.beginAt < $1.beginAt })
    }
    
    var body: some View {
        NavigationStack {
            if campusService.isLoading == false {
                List {
                    ForEach(activities) { activity in
                        NavigationLink(destination: EmptyView()) {
                            ActivityRow(type: activity.type, title: activity.title, description: activity.description)
                        }
                    }
                }
                .navigationTitle("Activities")
                .searchable(text: $searchText, prompt: "Search an activity")
                .refreshable { loadCampusActivities(refresh: true) }
            }
            else {
                ProgressView()
            }
        }
        .task { loadCampusActivities() }
    }
    
    private func loadCampusActivities(refresh: Bool = false) {
        guard let user = userService.user else { return }
        guard let campusId = user.mainCampus?.campusId, let cursusId = user.mainCursus?.cursusId else { return }
        
        Task {
            do {
                if refresh == true {
                    try await campusService.refreshCampusActivities(campusId: campusId, cursusId: cursusId)
                }
                else {
                    try await campusService.loadCampusActivities(campusId: campusId, cursusId: cursusId)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ActivitiesView()
        .environment(CampusService())
        .environment(UserService())
}
