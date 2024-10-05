//
//  UserEvents.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct UserEvents: View {
    @State private var searchedText: String = ""
    @State private var selectedFilter: String = ""
    
    let events: [Event]
    
    private var activities: [Activities] {
        let filteredEvents: [Event] = self.selectedFilter == "" ? self.events : self.events.filter { $0.kind.capitalized == self.selectedFilter }
        let events: [Activities] = filteredEvents.map { Activities.event($0) }.sorted(by: { $0.beginAt > $1.beginAt })
        
        guard self.searchedText.isEmpty == false else { return events }
        
        return events.filter { "\($0.title)".localizedStandardContains(self.searchedText) }
    }
    
    private var groupedActivities: [GroupedActivities] { GroupedActivities.create(for: self.activities, order: .DESC) }
    private var filters: [String] { Set(self.events.map(\.kind.capitalized)).sorted() }
    
    var body: some View {
        List(self.groupedActivities) { groupedActivity in
            if !groupedActivity.activities.isEmpty {
                Section(groupedActivity.monthYear) {
                    ForEach(groupedActivity.activities) { activity in
                        if case let .event(event) = activity {
                            NavigationLink(destination: EventDetailsView(event: event)) {
                                ActivityRow(type: activity.type, title: activity.title, description: activity.description)
                            }
                        }
                        else {
                            ActivityRow(type: activity.type, title: activity.title, description: activity.description)
                        }
                    }
                }
            }
        }
        .navigationTitle("Events")
        .searchable(text: self.$searchedText, prompt: "Search an event")
        .toolbar {
            ToolbarItem {
                FilterButton(selectedFilter: self.$selectedFilter, filters: self.filters)
            }
        }
        .overlay {
            if self.activities.isEmpty == true && self.searchedText.isEmpty == true {
                ContentUnavailableView(
                    "No activity found",
                    systemImage: "calendar",
                    description: Text("No activity found in your campus. Please check back later.")
                )
            }
            else if self.activities.isEmpty == true && self.searchedText.isEmpty == false {
                ContentUnavailableView.search(text: self.searchedText)
            }
        }
    }
}
