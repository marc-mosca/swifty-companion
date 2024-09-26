//
//  SettingsView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(UserService.self) private var userService
    @AppStorage(Constants.userIsConnectedKey) private var userIsConnected: Bool?
    @AppStorage(Constants.applicationLanguageKey) private var applicationLanguage: String?
    @AppStorage(Constants.applicationThemeKey) private var applicationTheme: Int?
    
    @State private var languageSelected = UserDefaults.standard.string(forKey: Constants.applicationLanguageKey) ?? Locale.preferredLanguages[0].components(separatedBy: "-").first ?? "en"
    @State private var themeSelected = UserDefaults.standard.integer(forKey: Constants.applicationThemeKey)
    
    private var applicationVersion: String {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("CFBundleShortVersionString should not be missing from info dictionary")
        }
        return version
    }
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    ApplicationIcon(width: 64, height: 64)
                    
                    Text("Dashboard42")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(applicationVersion)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 8))
                .padding(.vertical)
                
                Section("General") {
                    Picker("Language", selection: $languageSelected) {
                        ForEach(Languages.allCases) { language in
                            Text(language.title)
                                .tag(language.rawValue)
                        }
                    }
                    .onChange(of: languageSelected) { applicationLanguage = languageSelected }
                    
                    Picker("Theme", selection: $themeSelected) {
                        ForEach(Themes.allCases) { colorscheme in
                            Text(colorscheme.title)
                                .tag(colorscheme.rawValue)
                        }
                    }
                    .onChange(of: themeSelected) { applicationTheme = themeSelected }
                }
                
                Section("Help") {
                    CustomLink(title: "Report a problem", url: URL(string: "https://github.com/Dashboard42/Dashboard42/issues")!)
                }
                
                Section("Account") {
                    CustomLink(title: "Intranet Profile", url: URL(string: "https://profile.intra.42.fr/users/\(userService.user?.login ?? "")")!)
                    Button("Log out", role: .destructive, action: logOutButtonTapped)
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private func logOutButtonTapped() {
        userIsConnected = false
        KeychainManager.shared.clear()
    }
}

#Preview {
    SettingsView()
        .environment(UserService())
}

extension SettingsView {
    private struct CustomLink: View {
        let title: LocalizedStringKey
        let url: URL

        var body: some View {
            Link(destination: url) {
                HStack {
                    Text(title)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
        }
    }
}
