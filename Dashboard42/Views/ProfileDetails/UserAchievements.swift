//
//  UserAchievements.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct UserAchievements: View {
    @State private var searchedText: String = ""
    @State private var selectedFilter: String = ""
    
    let achievements: [User.Achievements]
    
    private var filteredAchievements: [User.Achievements] {
        let filteredAchievements: [User.Achievements] = self.selectedFilter == "" ? self.achievements : self.achievements.filter { $0.kind.capitalized == self.selectedFilter }
        
        guard self.searchedText.isEmpty == false else { return filteredAchievements }
        
        return filteredAchievements.filter { "\($0.name)".localizedStandardContains(self.searchedText) }
    }
    
    private var filters: [String] { Set(self.achievements.map(\.kind.capitalized)).sorted() }
    
    var body: some View {
        List(self.filteredAchievements) { achievement in
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
        .searchable(text: self.$searchedText, prompt: "Search an achievement")
        .toolbar {
            ToolbarItem {
                FilterButton(selectedFilter: self.$selectedFilter, filters: self.filters)
            }
        }
        .overlay {
            if self.filteredAchievements.isEmpty == true && self.searchedText.isEmpty == true {
                ContentUnavailableView(
                    "No achivements found",
                    systemImage: "rosette",
                    description: Text("You must complete goals to unlock achievements.")
                )
            }
            else if self.filteredAchievements.isEmpty == true && self.searchedText.isEmpty == false {
                ContentUnavailableView.search(text: self.searchedText)
            }
        }
    }
}
