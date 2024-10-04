//
//  ActivitiesView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import SwiftUI

struct ActivitiesView: View {
    @Environment(\.campusService) private var campusService: CampusService
    @Environment(\.userService) private var userService: UserService
    
    @State private var isFirstLoad: Bool = true
    @State private var isLoading: Bool = false
    
    @State private var error: Dashboard42UIErrors? = nil
    @State private var hasError: Bool = false
    
    @State private var searchedText: String = ""
    @State private var selectedFilter: String = ""
    
    private var activities: [Activities] {
        let campusEvents: [Event] = self.campusService.events
        let filteredEvents: [Event] = self.selectedFilter == "" ? campusEvents : campusEvents.filter { $0.kind.capitalized == self.selectedFilter }
        let events: [Activities] = filteredEvents.map { Activities.event($0) }
        let exams: [Activities] = self.selectedFilter == "" ? self.campusService.exams.map { Activities.exam($0) } : []
        let homeActivities: [Activities] = (events + exams).sorted(by: { $0.beginAt < $1.beginAt })
        
        guard self.searchedText.isEmpty == false else { return homeActivities }
        
        return homeActivities.filter { "\($0.title)".localizedStandardContains(self.searchedText) }
    }
    
    private var groupedActivities: [GroupedActivities] { GroupedActivities.create(for: self.activities, order: .ASC) }
    private var filters: [String] { Set(self.campusService.events.map(\.kind.capitalized)).sorted() }
    
    var body: some View {
        NavigationStack {
            if self.isLoading == false {
                List(self.groupedActivities) { groupedActivity in
                    if groupedActivity.activities.isEmpty == false {
                        Section(groupedActivity.monthYear) {
                            ForEach(groupedActivity.activities) { activity in
                                if case let .event(event) = activity {
                                    NavigationLink(destination: EventDetailsView(event: event)) {
                                        ActivityRow(type: activity.type, title: activity.title, description: activity.description)
                                    }
                                }
                                else if case let .exam(exam) = activity {
                                    NavigationLink(destination: ExamDetailsView(exam: exam)) {
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
                .navigationTitle("Activities")
                .searchable(text: self.$searchedText, prompt: "Search an activity")
                .refreshable {
                    await self.fetchCampusActivities()
                }
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
            else {
                ProgressView()
            }
        }
        .error(isPresented: self.$hasError, error: self.error)
    }

    
    private func fetchCampusActivities() async -> Void {
        guard let user: User = self.userService.user else { return }
        guard let campusId: Int = user.mainCampus?.campusId else { return }
        guard let cursusId: Int = user.mainCursus?.cursusId else { return }
        
        self.isLoading = true
        
        do {
            try await self.campusService.fetchEvents(campusId: campusId, cursusId: cursusId)
            try await self.campusService.fetchExams(campusId: campusId)
        }
        catch {
            self.error = .cannotFetchCampusActivities
            self.hasError = true
        }
        
        self.isFirstLoad = false
        self.isLoading = false
    }
}

#Preview {
    ActivitiesView()
}
