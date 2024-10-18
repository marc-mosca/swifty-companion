//
//  SettingsView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.userService) private var userService: UserService

    @AppStorage(Constants.userIsConnectedKey) private var userIsConnected: Bool = false
    @AppStorage(Constants.applicationLanguageKey) private var applicationLanguage: String?
    @AppStorage(Constants.applicationThemeKey) private var applicationTheme: Int?
    
    @State private var languageSelected: String = UserDefaults.standard.string(forKey: Constants.applicationLanguageKey) ?? Locale.preferredLanguages[0].components(separatedBy: "-").first ?? "en"
    @State private var themeSelected: Int = UserDefaults.standard.integer(forKey: Constants.applicationThemeKey)
    @State private var presentDialog: Bool = false
    
    private var applicationVersion: String {
        guard let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
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
                    
                    Text("Version \(self.applicationVersion)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 8))
                .padding(.vertical)
                
                Section("General") {
                    Picker("Language", selection: self.$languageSelected) {
                        ForEach(Languages.allCases) { language in
                            Text(language.title)
                                .tag(language.rawValue)
                        }
                    }
                    .onChange(of: self.languageSelected) { self.applicationLanguage = self.languageSelected }
                    
                    Picker("Theme", selection: self.$themeSelected) {
                        ForEach(Themes.allCases) { colorscheme in
                            Text(colorscheme.title)
                                .tag(colorscheme.rawValue)
                        }
                    }
                    .onChange(of: self.themeSelected) { self.applicationTheme = self.themeSelected }
                }
                
                Section("Help") {
                    CustomLink(title: "Report a problem", url: URL(string: "https://github.com/marc-mosca/Dashboard42/issues")!)
                }
                
                Section("Account") {
                    CustomLink(title: "Intranet Profile", url: URL(string: "https://profile.intra.42.fr/users/\(self.userService.user?.login ?? "")")!)
                    Button("Log out", role: .destructive) {
                        self.presentDialog = true
                    }
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Are you sure you want to log out?", isPresented: self.$presentDialog) {
                Button("Log out", role: .destructive) {
                    self.logOutButtonTapped()
                }
            }
        }
    }
    
    private func logOutButtonTapped() -> Void {
        withAnimation {
            self.userIsConnected = false
            KeychainService.shared.clear()
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    private struct CustomLink: View {
        let title: LocalizedStringKey
        let url: URL

        var body: some View {
            Link(destination: self.url) {
                HStack {
                    Text(self.title)
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
