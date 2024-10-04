//
//  UserPatronages.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 04/10/2024.
//

import SwiftUI

struct UserPatronages: View {
    @Environment(\.userService) private var userService: UserService
    
    @State private var isFirstLoad: Bool = true
    @State private var isLoading: Bool = false
    
    @State private var error: Dashboard42UIErrors? = nil
    @State private var hasError: Bool = false
    
    @State private var userPatroned: [User] = []
    @State private var userPatroning: [User] = []
    
    let patroned: [User.Patronages]
    let patroning: [User.Patronages]

    var body: some View {
        VStack {
            if self.isLoading == true {
                ProgressView()
            }
            else {
                List {
                    if self.userPatroned.isEmpty == false {
                        Section("Patroned") {
                            ForEach(self.userPatroned) { user in
                                UserCard(user: user)
                            }
                        }
                    }
                    
                    if self.userPatroning.isEmpty == false {
                        Section("Patroning") {
                            ForEach(self.userPatroning) { user in
                                UserCard(user: user)
                            }
                        }
                    }
                }
                .overlay {
                    if self.hasError == true {
                        ContentUnavailableView("No patronages found", systemImage: "person.2")
                    }
                }
            }
        }
        .navigationTitle("Patronages")
        .error(isPresented: self.$hasError, error: self.error)
        .task {
            guard self.isFirstLoad == true else { return }
            await self.fetchUserPatronages()
        }
    }
    
    private func fetchUserPatronages() async -> Void {
        self.isLoading = true
        
        do {
            for user in self.patroned {
                let result: User = try await self.userService.fetchUser(login: String(user.godfatherId))
                self.userPatroned.append(result)
            }
            
            for user in self.patroning {
                let result: User = try await self.userService.fetchUser(login: String(user.userId))
                self.userPatroning.append(result)
            }
        }
        catch {
            self.error = .userNotFound
            self.hasError = true
        }
        
        self.isFirstLoad = false
        self.isLoading = false
    }
}

extension UserPatronages {
    private struct UserCard: View {
        let user: User
        
        var body: some View {
            NavigationLink(destination: ProfileView(user: self.user)) {
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: self.user.image.link)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(.circle)

                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(self.user.displayname)
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(self.user.email)
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 8)
            }
        }
    }
}
