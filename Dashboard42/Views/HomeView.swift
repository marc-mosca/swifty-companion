//
//  HomeView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 26/09/2024.
//

import SwiftUI

struct HomeView<T: View>: View {
    @Environment(UserService.self) private var userService
    @State private var searchText = ""
    @State private var searchedUser: User?
    @State private var searchFailed: Bool = false
    @State private var isSearchedSucceded: Bool?
    
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
            if let user = userService.user, userService.isLoading == false {
                List {
                    Section {
                        ActivityRow(
                            type: .project,
                            title: "Projects",
                            description: nil,
                            destination: UserProjects<T>(projects: user.projectsUsers, cursus: user.cursusUsers)
                        )
                        
                        ActivityRow(type: .scale, title: "Scales", description: nil, destination: EmptyView())
                        ActivityRow(type: .logtime, title: "Logtimes", description: nil, destination: EmptyView())
                        ActivityRow(type: .event, title: "Events", description: nil, destination: UserEvents<T>(events: userService.events))
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
                                ActivityRow<T>(activity: activity)
                            }
                        }
                    } header: {
                        SectionHeader(header: "Recent")
                    }
                }
                .navigationTitle("Home")
                .searchable(text: $searchText, prompt: "Search a student")
                .refreshable { loadUserInformations() }
                .onAppear { isSearchedSucceded = nil }
                .onChange(of: searchText) { isSearchedSucceded = nil }
                .onSubmit(of: .search) { searchUser() }
                .navigationDestination(isPresented: .constant(isSearchedSucceded == true)) {
                    if let user = searchedUser {
                        ProfileView<T>(user: user)
                    }
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
        .alert("No user found", isPresented: $searchFailed) {
            Button("OK", role: .cancel, action: {})
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
    
    private func searchUser() {
        Task {
            do {
                searchedUser = try await NetworkingManager.shared.request(UserEndpoints.fetchUser(login: searchText.lowercased()), type: User.self)
                isSearchedSucceded = true
            }
            catch {
                searchFailed = true
            }
        }
    }
}

#Preview {
    HomeView<EmptyView>()
        .environment(UserService())
}
