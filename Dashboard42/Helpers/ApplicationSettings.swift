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
        case .fr: return "Français"
        case .en: return "English"
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
        case .automatic: return "Automatic"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var scheme: ColorScheme? {
        switch self {
        case .automatic: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
