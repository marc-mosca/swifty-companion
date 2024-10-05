//
//  HomeView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 26/09/2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.userService) private var userService: UserService
    
    @State private var isLoading: Bool = false
    
    @State private var error: Dashboard42UIErrors? = nil
    @State private var hasError: Bool = false
    
    @State private var searchedText: String = ""
    @State private var searchedUser: User? = nil
    @State private var searchedSucceeded: Bool = false
    
    private var activities: [Activities] {
        let events: [Activities] = self.userService.events.map { Activities.event($0) }
        let exams: [Activities] = self.userService.exams.map { Activities.exam($0) }
        let scales: [Activities] = self.userService.scales.map { Activities.scale($0) }
        let projects: [Activities] = self.userService.user?.projectsUsers.map { Activities.project($0) } ?? []
        
        return (events + exams + scales + projects).sorted { $0.beginAt > $1.beginAt }
    }
    
    var body: some View {
        NavigationStack {
            if let user: User = self.userService.user, self.isLoading == false {
                List {
                    Section {
                        NavigationLink(destination: UserProjects(projects: user.projectsUsers, cursus: user.cursusUsers)) {
                            ActivityRow(type: .project(project: nil), title: "Projects", description: nil)
                        }
                        
                        NavigationLink(destination: EmptyView()) {
                            ActivityRow(type: .scale, title: "Scales", description: nil)
                        }
                        
                        NavigationLink(destination: UserLogtimes()) {
                            ActivityRow(type: .logtime, title: "Logtimes", description: nil)
                        }
                        
                        NavigationLink(destination: UserEvents(events: self.userService.events)) {
                            ActivityRow(type: .event, title: "Events", description: nil)
                        }
                    } header: {
                        SectionHeader(header: "Shortcuts")
                    }
                    
                    Section {
                        if self.activities.isEmpty == true {
                            ContentUnavailableView(
                                "No recent activity",
                                systemImage: "calendar",
                                description: Text("No recent activity was found on your profile.")
                            )
                        }
                        else {
                            ForEach(self.activities.prefix(10)) { activity in
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
                    } header: {
                        SectionHeader(header: "Recent")
                    }
                }
                .navigationTitle("Home")
                .searchable(text: self.$searchedText, prompt: "Search a student")
                .refreshable { await self.fetchUserInformations() }
                .onSubmit(of: .search) { self.fetchUser() }
                .navigationDestination(isPresented: .constant(self.searchedSucceeded == true)) {
                    if let user: User = self.searchedUser {
                        ProfileView(user: user)
                    }
                }
            }
            else {
                ProgressView()
            }
        }
        .error(isPresented: $hasError, error: self.error)
    }
    
    private func fetchUserInformations() async -> Void {
        self.isLoading = true
        
        do {
            try await self.userService.fetchConnectedUser()
            
            guard let user: User = self.userService.user else { return }
            
            try await self.userService.fetchEvents(userId: user.id)
            try await self.userService.fetchExams(userId: user.id)
            try await self.userService.fetchScales()
            try await self.userService.fetchSlots()
            try await self.userService.fetchCorrectionPointHistorics(userId: user.id)
            try await self.userService.fetchLogtimes(login: user.login, entryDate: user.entryDate)
        }
        catch {
            self.error = .cannotFetchUserInformations
            self.hasError = true
        }
        
        self.isLoading = false
    }
    
    private func fetchUser() -> Void {
        Task {
            self.isLoading = true
            
            do {
                self.searchedUser = try await self.userService.fetchUser(login: self.searchedText.lowercased())
                self.searchedSucceeded = true
            }
            catch {
                self.error = .userNotFound
                self.hasError = true
                self.searchedSucceeded = false
            }
            
            self.isLoading = false
        }
    }
}

#Preview {
    HomeView()
}
