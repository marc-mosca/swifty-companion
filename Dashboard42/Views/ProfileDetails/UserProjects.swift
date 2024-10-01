//
//  UserProjects.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct UserProjects<T: View>: View {
    @State private var selectedFilter = ""
    @State private var searchText = ""
    
    let projects: [User.Projects]
    let cursus: [User.Cursus]
    
    private var activities: [Activities] {
        let cursusId = cursus.first(where: { $0.cursus.name.capitalized == selectedFilter })?.cursus.id
        let filteredProjects = selectedFilter == "" ? projects : projects.filter { $0.cursusIds.first == cursusId }
        let activitiesProjects = filteredProjects.map({ Activities.project($0) }).sorted(by: { $0.beginAt > $1.beginAt })
        
        guard !searchText.isEmpty else { return activitiesProjects }
        
        return activitiesProjects.filter { "\($0.title)".localizedStandardContains(searchText) }
    }
    
    private var groupedActivities: [GroupedActivities] { GroupedActivities.create(for: activities, asc: false) }
    private var filters: [String] { Set(cursus.map(\.cursus.name.capitalized)).sorted() }
    
    var body: some View {
        List(groupedActivities) { groupedActivity in
            if !groupedActivity.activities.isEmpty {
                Section(groupedActivity.monthYear) {
                    ForEach(groupedActivity.activities) { activity in
                        ActivityRow<T>(activity: activity)
                    }
                }
            }
        }
        .navigationTitle("Projects")
        .searchable(text: $searchText, prompt: "Search for a project")
        .toolbar {
            ToolbarItem {
                FilterButton(selectedFilter: $selectedFilter, filters: filters)
            }
        }
        .overlay {
            if activities.isEmpty && searchText.isEmpty {
                ContentUnavailableView(
                    "No project found",
                    systemImage: "folder",
                    description: Text("You must be registered or have submitted a project to see it in the list.")
                )
            }
            else if activities.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }
}
