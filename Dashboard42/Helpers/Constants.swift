//
//  Constants.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 19/09/2024.
//

import Foundation

enum Constants {
    private static let bundle: Bundle = .main
    
    static let userIsConnectedKey: String = "APPSTORAGE_USER_IS_CONNECTED_KEY"
    static let applicationLanguageKey: String = "APPSTORAGE_APPLICATION_LANGUAGE_KEY"
    static let applicationThemeKey: String = "APPSTORAGE_APPLICATION_THEME_KEY"
    
    static var clientID: String {
        guard let clientID: String = bundle.infoDictionary?["API_CLIENT_ID"] as? String else { error(key: "API_CLIENT_ID") }
        return clientID
    }
    
    static var clientSecret: String {
        guard let clientSecret: String = bundle.infoDictionary?["API_CLIENT_SECRET"] as? String else { error(key: "API_CLIENT_SECRET") }
        return clientSecret
    }
    
    static var redirectURI: String {
        guard let redirectURI: String = bundle.infoDictionary?["API_REDIRECT_URI"] as? String else { error(key: "API_REDIRECT_URI") }
        return redirectURI
    }
    
    private static func error(key: String) -> Never {
        fatalError("Error: missing \(key) in Info.plist file.")
    }
}
