//
//  ApplicationScreens.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import SwiftUI

enum ApplicationScreens: Identifiable, CaseIterable {
    case home
    case activities
    case profile
    case settings
    
    var id: Self { self }
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .home: Label("Home", systemImage: "house")
        case .activities: Label("Activities", systemImage: "calendar")
        case .profile: Label("Profile", systemImage: "person")
        case .settings: Label("Settings", systemImage: "slider.horizontal.3")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home: Text("Home")
        case .activities: Text("Activities")
        case .profile: Text("Profile")
        case .settings: SettingsView()
        }
    }
}
