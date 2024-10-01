//
//  UserEvents.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct UserEvents<T: View>: View {
    @State private var selectedFilter = ""
    @State private var searchText = ""
    
    let events: [Event]
    
    private var activities: [Activities] {
        let filteredEvents = selectedFilter == "" ? events : events.filter { $0.kind.capitalized == selectedFilter }
        let events = filteredEvents.map { Activities.event($0) }.sorted(by: { $0.beginAt > $1.beginAt })
        
        guard !searchText.isEmpty else { return events }
        
        return events.filter { "\($0.title)".localizedStandardContains(searchText) }
    }
    
    private var groupedActivities: [GroupedActivities] { GroupedActivities.create(for: activities, asc: false) }
    private var activityFilters: [String] { Set(events.map(\.kind.capitalized)).sorted() }
    
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
        .navigationTitle("Events")
        .searchable(text: $searchText, prompt: "Search an event")
        .toolbar {
            ToolbarItem {
                FilterButton(selectedFilter: $selectedFilter, filters: activityFilters)
            }
        }
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
}
