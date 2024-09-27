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
        let homeActivities = (events + exams).sorted(by: { $0.beginAt < $1.beginAt })
        
        guard !searchText.isEmpty else { return homeActivities }
        
        return homeActivities.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    private var groupedActivities: [GroupedActivities] { GroupedActivities.create(for: activities) }
    
    var body: some View {
        NavigationStack {
            if campusService.isLoading == false {
                List(groupedActivities) { groupedActivity in
                    if !groupedActivity.activities.isEmpty {
                        Section(groupedActivity.monthYear) {
                            ForEach(groupedActivity.activities) { activity in
                                NavigationLink(destination: EmptyView()) {
                                    ActivityRow(type: activity.type, title: activity.title, description: activity.description)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Activities")
                .searchable(text: $searchText, prompt: "Search an activity")
                .refreshable { loadCampusActivities(refresh: true) }
                .overlay {
                    if activities.isEmpty && searchText.isEmpty {
                        ContentUnavailableView(
                            "No activity found",
                            systemImage: "calendar",
                            description: Text("No activity found in your campus. Please check back later.")
                        )
                    }
                    else if activities.isEmpty && !searchText.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                    }
                }
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
