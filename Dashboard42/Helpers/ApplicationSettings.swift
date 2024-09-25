//
//  ApplicationSettings.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 25/09/2024.
//

import SwiftUI

enum Languages: String, Identifiable, CaseIterable {
    case fr = "fr"
    case en = "en"
    
    var id: UUID { UUID() }
    
    var title: String {
        switch self {
        case .fr: "Français"
        case .en: "English"
        }
    }
}

enum Themes: Int, Identifiable, CaseIterable {
    case automatic = 0
    case light = 1
    case dark = 2
    
    var id: UUID { UUID() }
    
    var title: LocalizedStringKey {
        switch self {
        case .automatic: "Automatic"
        case .light: "Light"
        case .dark: "Dark"
        }
    }
    
    var scheme: ColorScheme? {
        switch self {
        case .automatic: nil
        case .light: .light
        case .dark: .dark
        }
    }
}
