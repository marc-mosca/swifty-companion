//
//  ProfileView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.userService) private var userService: UserService
    
    let userParam: User?
    let isSearchedProfile: Bool
    
    init() {
        self.userParam = nil
        self.isSearchedProfile = false
    }
    
    init(user: User) {
        self.userParam = user
        self.isSearchedProfile = true
    }
    
    private var user: User? { self.isSearchedProfile ? userParam : self.userService.user }
    
    var body: some View {
        NavigationStack {
            if let user: User = self.user {
                List {
                    Section {
                        VStack(spacing: 30) {
                            HStack(spacing: 20) {
                                Avatar(url: user.image.link, isAvailable: user.location != nil)
                                Informations(name: user.displayname, email: user.email, isPostCommonCore: user.isPostCC, cursus: user.mainCursus)
                            }
                            .padding(.horizontal, 8)
                            
                            GridInformations(location: user.location, grade: user.mainCursus?.grade, poolYear: user.poolYear)
                        }
                    }
                    .listRowInsets(.some(.init()))
                    .padding(4)
                    .padding(.vertical, 6)
                    
                    Section {
                        NavigationLink(destination: UserInformations(user: user)) {
                            ActivityRow(type: .info, title: "Informations", description: nil)
                        }
                        
                        NavigationLink(destination: UserProjects(projects: user.projectsUsers, cursus: user.cursusUsers)) {
                            ActivityRow(type: .project(project: nil), title: "Projects", description: nil)
                        }
                        
                        if self.isSearchedProfile == false {
                            NavigationLink(destination: UserEvents(events: self.userService.events)) {
                                ActivityRow(type: .event, title: "Events", description: nil)
                            }
                            
                            NavigationLink(destination: EmptyView()) {
                                ActivityRow(type: .scale, title: "Scales", description: nil)
                            }
                            
                            NavigationLink(destination: EmptyView()) {
                                ActivityRow(type: .logtime, title: "Logtimes", description: nil)
                            }
                        }
                        
                        NavigationLink(destination: UserAchievements(achievements: user.achievements)) {
                            ActivityRow(type: .achievement, title: "Achievements", description: nil)
                        }
                        
                        if user.patroned.isEmpty == false || user.patroning.isEmpty == false {
                            NavigationLink(destination: UserPatronages(patroned: user.patroned, patroning: user.patroning)) {
                                ActivityRow(type: .patronage, title: "Patronages", description: nil)
                            }
                        }
                    } header: {
                        SectionHeader(header: "Dashboard")
                    }
                }
                .navigationTitle(user.login)
                .navigationBarTitleDisplayMode(.inline)
            }
            else {
                ProgressView()
            }
        }
    }
}

#Preview {
    ProfileView()
}

extension ProfileView {
    
    // MARK: Informations
    
    private struct Informations: View {
        let name: String
        let email: String
        let isPostCommonCore: Bool
        let cursus: User.Cursus?
        
        private var level: Double { self.cursus?.level ?? 0 }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(self.name)
                            .foregroundStyle(.primary)
                            .font(.system(.title2, weight: .bold))
                        
                        Spacer()
                        
                        if self.isPostCommonCore == true {
                            Image(systemName: "checkmark.seal.fill")
                                .imageScale(.small)
                                .padding(.vertical, 4)
                                .foregroundStyle(.accent)
                        }
                    }
                    
                    Text(self.email)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                
                ProgressView(
                    value: self.cursus?.level != nil ? (level > 21 ? 21 : level) : 0.0,
                    total: 21
                ) {
                    HStack {
                        Image(systemName: "trophy")
                            .imageScale(.small)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Level - \(level.formatted())")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(self.cursus?.cursus.name ?? "Undefined")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                .tint(.accent)
            }
        }
    }
    
    // MARK: Grid Informations
    
    private struct GridInformations: View {
        let location: String?
        let grade: String?
        let poolYear: String
        
        var body: some View {
            HStack {
                GridInformationItem(title: "Location", value: self.location != nil ? "\(self.location!.uppercased())" : "Undefined")
                GridInformationItem(title: "Grade", value: self.grade != nil ? "\(self.grade!)" : "Undefined")
                GridInformationItem(title: "Promotion", value: "\(self.poolYear)")
            }
        }
    }
    
    private struct GridInformationItem: View {
        let title: LocalizedStringKey
        let value: LocalizedStringKey
        
        var body: some View {
            VStack(spacing: 8) {
                Text(self.title)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                
                Text(self.value)
                    .foregroundStyle(.primary)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
}
