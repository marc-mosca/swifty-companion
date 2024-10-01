//
//  UserAchievements.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct UserAchievements<T: View>: View {
    @State private var selectedFilter = ""
    @State private var searchText = ""
    
    let achievements: [User.Achievements]
    
    private var filteredAchievements: [User.Achievements] {
        let filteredAchievements = selectedFilter == "" ? achievements : achievements.filter { $0.kind.capitalized == selectedFilter }
        
        guard !searchText.isEmpty else { return filteredAchievements }
        
        return filteredAchievements.filter { "\($0.name)".localizedStandardContains(searchText) }
    }
    
    private var filters: [String] { Set(achievements.map(\.kind.capitalized)).sorted() }
    
    var body: some View {
        List(filteredAchievements) { achievement in
            HStack(spacing: 16) {
                Image(systemName: "rosette")
                    .imageScale(.large)
                    .foregroundStyle(.brown.gradient)
                
                VStack(alignment: .leading) {
                    Text(achievement.name)
                    
                    Text(achievement.description)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Achievements")
        .searchable(text: $searchText, prompt: "Search an achievement")
        .toolbar {
            ToolbarItem {
                FilterButton(selectedFilter: $selectedFilter, filters: filters)
            }
        }
        .overlay {
            if filteredAchievements.isEmpty && searchText.isEmpty {
                ContentUnavailableView(
                    "No achivements found",
                    systemImage: "rosette",
                    description: Text("You must complete goals to unlock achievements.")
                )
            }
            else if filteredAchievements.isEmpty && !searchText.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }
}
