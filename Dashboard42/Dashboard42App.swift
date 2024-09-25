//
//  Dashboard42App.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

@main
struct Dashboard42App: App {
    @AppStorage(Constants.applicationLanguageKey) private var applicationLanguage: String?
    @AppStorage(Constants.applicationThemeKey) private var applicationTheme: Int?

    @State private var authenticationService = AuthenticationService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(Themes(rawValue: applicationTheme ?? 0)?.scheme)
                .environment(\.locale, .init(identifier: applicationLanguage ?? Locale.current.identifier))
                .environment(authenticationService)
        }
    }
}
