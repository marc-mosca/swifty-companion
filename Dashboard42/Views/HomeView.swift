//
//  HomeView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 26/09/2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(UserService.self) private var userService
    @State private var searchText = ""
    
    private var activities: [Activities] {
        let events = userService.events.map { Activities.event($0) }
        let exams = userService.exams.map { Activities.exam($0) }
        let scales = userService.scales.map { Activities.scale($0) }
        let projects = userService.user?.projectsUsers.map { Activities.project($0) } ?? []
        let homeActivities = events + exams + scales + projects
        
        return homeActivities.sorted(by: { $0.beginAt > $1.beginAt })
    }
    
    var body: some View {
        NavigationStack {
            if userService.isLoading == false {
                List {
                    Section {
                        NavigationLink(destination: EmptyView()) {
                            ActivityRow(type: .project, title: "Projects", description: nil)
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            ActivityRow(type: .scale, title: "Scales", description: nil)
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            ActivityRow(type: .logtime, title: "Logtimes", description: nil)
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            ActivityRow(type: .event(isSubscribe: false), title: "Events", description: nil)
                        }
                    } header: {
                        SectionHeader(header: "Shortcuts")
                    }
                    
                    Section {
                        if activities.isEmpty {
                            ContentUnavailableView(
                                "No recent activity",
                                systemImage: "calendar",
                                description: Text("No recent activity was found on your profile.")
                            )
                        }
                        else {
                            ForEach(activities.prefix(10)) { activity in
                                ActivityRow(type: activity.type, title: activity.title, description: activity.description)
                            }
                        }
                    } header: {
                        SectionHeader(header: "Recent")
                    }
                }
                .navigationTitle("Home")
                .searchable(text: $searchText, prompt: "Search a student")
                .refreshable {
                    loadUserInformations()
                }
            }
            else {
                ProgressView()
            }
        }
        .task {
            guard userService.user == nil else { return }
            loadUserInformations()
        }
    }
    
    private func loadUserInformations() {
        Task {
            do {
                try await userService.loadUserInformations()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(UserService())
}

extension HomeView {
    private struct SectionHeader: View {
        let header: LocalizedStringKey
        
        var body: some View {
            Text(header)
                .textCase(.none)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding(.vertical)
                .listRowInsets(EdgeInsets())
        }
    }

    enum Activities: Identifiable {
        case project(User.Projects)
        case exam(Exam)
        case scale(Scale)
        case event(Event)
        
        var id: Int {
            switch self {
            case .project(let project): project.id
            case .exam(let exam): exam.id
            case .scale(let scale): scale.id
            case .event(let event): event.id
            }
        }
        
        var type: ActivityType {
            switch self {
            case .project: .project
            case .exam: .exam
            case .scale: .scale
            case .event: .event(isSubscribe: false)
            }
        }
        
        var title: String {
            switch self {
            case .project(let project): project.project.name
            case .exam(let exam): exam.name
            case .scale: "Scale"
            case .event(let event): event.name
            }
        }
        
        var description: String? {
            switch self {
            case .project(let project): project.markedAt?.formatted() ?? project.status.replacingOccurrences(of: "_", with: " ").capitalized
            case .exam(let exam): exam.beginAt.formatted()
            case .scale(let scale): scale.beginAt.formatted()
            case .event(let event): event.beginAt.formatted()
            }
        }
        
        var beginAt: Date {
            switch self {
            case .project(let project): project.markedAt ?? Date()
            case .exam(let exam): exam.beginAt
            case .scale(let scale): scale.beginAt
            case .event(let event): event.beginAt
            }
        }
    }
}
