//
//  ProfileView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @Environment(UserService.self) private var userService
    
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
    
    private var user: User? { isSearchedProfile ? userParam : userService.user }
    
    var body: some View {
        NavigationStack {
            if let user {
                List {
                    Section {
                        VStack(spacing: 30) {
                            HStack(spacing: 20) {
                                Avatar(url: user.image.link, isAvailable: user.location != nil)
                                Informations(name: user.displayname, email: user.email, isPostCommonCore: user.isPostCC, cursus: user.mainCursus)
                            }
                            .padding(.horizontal, 4)
                            
                            GridInformations(location: user.location, grade: user.mainCursus?.grade, poolYear: user.poolYear)
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .padding(4)
                    .padding(.vertical, 6)
                    
                    Section {
                        ActivityRow(type: .info, title: "Informations", destination: EmptyView())
                        ActivityRow(type: .project, title: "Projects", destination: EmptyView())
                        ActivityRow(type: .event, title: "Events", destination: EmptyView())
                        ActivityRow(type: .scale, title: "Scales", destination: EmptyView())
                        ActivityRow(type: .logtime, title: "Logtimes", destination: EmptyView())
                        ActivityRow(type: .achievement, title: "Achievements", destination: EmptyView())
                        ActivityRow(type: .patronage, title: "Patronages", destination: EmptyView())
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
        .environment(UserService())
}

extension ProfileView {
    
    // MARK: Informations
    
    private struct Informations: View {
        let name: String
        let email: String
        let isPostCommonCore: Bool
        let cursus: User.Cursus?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(name)
                            .foregroundStyle(.primary)
                            .font(.system(.title2, weight: .bold))
                        
                        Spacer()
                        
                        if isPostCommonCore {
                            Image(systemName: "checkmark.seal.fill")
                                .imageScale(.small)
                                .padding(.vertical, 4)
                                .foregroundStyle(.accent)
                        }
                    }
                    
                    Text(email)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                }
                
                ProgressView(
                    value: cursus?.level != nil ? (cursus!.level > 21 ? 21 : cursus!.level) : 0.0,
                    total: 21
                ) {
                    HStack {
                        Image(systemName: "trophy")
                            .imageScale(.small)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Level - \(cursus?.level.formatted() ?? "0")")
                            .font(.footnote)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(cursus?.cursus.name ?? "Undefined")
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
                GridInformationItem(title: "Location", value: location != nil ? "\(location!.uppercased())" : "Undefined")
                GridInformationItem(title: "Grade", value: grade != nil ? "\(grade!)" : "Undefined")
                GridInformationItem(title: "Promotion", value: "\(poolYear)")
            }
        }
    }
    
    private struct GridInformationItem: View {
        let title: LocalizedStringKey
        let value: LocalizedStringKey
        
        var body: some View {
            VStack(spacing: 8) {
                Text(title)
                    .foregroundStyle(.secondary)
                    .font(.footnote)
                
                Text(value)
                    .foregroundStyle(.primary)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
}
