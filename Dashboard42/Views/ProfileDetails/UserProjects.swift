//
//  UserProjects.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct UserProjects: View {
    @State private var searchedText: String = ""
    @State private var selectedFilter: String = ""
    
    let projects: [User.Projects]
    let cursus: [User.Cursus]
    
    private var activities: [Activities] {
        let cursusId: Int? = self.cursus.first(where: { $0.cursus.name.capitalized == self.selectedFilter })?.cursus.id
        let filteredProjects: [User.Projects] = self.selectedFilter == "" ? self.projects : self.projects.filter { $0.cursusIds.first == cursusId }
        let activitiesProjects: [Activities] = filteredProjects.map({ Activities.project($0) }).sorted(by: { $0.beginAt > $1.beginAt })
        
        guard self.searchedText.isEmpty == false else { return activitiesProjects }
        
        return activitiesProjects.filter { "\($0.title)".localizedStandardContains(self.searchedText) }
    }
    
    private var groupedActivities: [GroupedActivities] { GroupedActivities.create(for: self.activities, order: .DESC) }
    private var filters: [String] { Set(self.cursus.map(\.cursus.name.capitalized)).sorted() }
    
    var body: some View {
        List(self.groupedActivities) { groupedActivity in
            if !groupedActivity.activities.isEmpty {
                Section(groupedActivity.monthYear) {
                    ForEach(groupedActivity.activities) { activity in
                        ActivityRow(type: activity.type, title: activity.title, description: activity.description)
                    }
                }
            }
        }
        .navigationTitle("Projects")
        .searchable(text: self.$searchedText, prompt: "Search a project")
        .toolbar {
            ToolbarItem {
                FilterButton(selectedFilter: self.$selectedFilter, filters: self.filters)
            }
        }
        .overlay {
            if self.activities.isEmpty == true && self.searchedText.isEmpty == true {
                ContentUnavailableView(
                    "No project found",
                    systemImage: "folder",
                    description: Text("You must be registered or have submitted a project to see it in the list.")
                )
            }
            else if self.activities.isEmpty == true && self.searchedText.isEmpty == false {
                ContentUnavailableView.search(text: self.searchedText)
            }
        }
    }
}
