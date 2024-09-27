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
    
    var body: some View {
        NavigationStack {
            if let user = userService.user {
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
                        ForEach(user.projectsUsers) { project in
                            ActivityRow(type: .project, title: project.project.name, description: project.status)
                        }
                    } header: {
                        SectionHeader(header: "Recent")
                    }
                }
                .navigationTitle("Home")
                .searchable(text: $searchText, prompt: "Search a student")
            }
            else {
                ProgressView()
            }
        }
        .task { loadUserInformations() }
    }
    
    private func loadUserInformations() {
        guard userService.user == nil else { return }

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
}
