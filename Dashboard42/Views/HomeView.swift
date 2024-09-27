//
//  HomeView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 26/09/2024.
//

import SwiftUI

struct HomeView: View {
    @Environment(UserService.self) private var userService
    
    var body: some View {
        NavigationStack {
            if let user = userService.user {
                List {
                    Text(user.displayname)
                }
                .navigationTitle("Home")
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
                try await userService.loadUser()
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
