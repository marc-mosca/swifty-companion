//
//  Dashboard42App.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

@main
struct Dashboard42App: App {
    @AppStorage(Constants.applicationLanguageKey) private var applicationLanguage: String = Locale.current.identifier
    @AppStorage(Constants.applicationThemeKey) private var applicationTheme: Int = 0

    @State var authenticationService: AuthenticationService = .init()
    @State var campusService: CampusService = .init()
    @State var userService: UserService = .init()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(Themes(rawValue: self.applicationTheme)?.scheme)
                .environment(\.locale, .init(identifier: self.applicationLanguage))
                .environment(\.authenticationService, self.authenticationService)
                .environment(\.campusService, self.campusService)
                .environment(\.userService, self.userService)
        }
    }
}
