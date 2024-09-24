//
//  Constants.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 19/09/2024.
//

import Foundation

enum Constants {
    private static let infoDictionary = Bundle.main.infoDictionary
    
    static let userIsConnectedKey = "APPSTORAGE_USER_IS_CONNECTED_KEY"
    
    static var clientID: String {
        guard let infoDictionary, let clientID: String = infoDictionary["API_CLIENT_ID"] as? String else {
            fatalError("Missing API_CLIENT_ID in Info.plist")
        }

        return clientID
    }
    
    static var clientSecret: String {
        guard let infoDictionary, let clientSecret: String = infoDictionary["API_CLIENT_SECRET"] as? String else {
            fatalError("Missing API_CLIENT_SECRET in Info.plist")
        }
        
        return clientSecret
    }
    
    static var redirectURI: String {
        guard let infoDictionary, let redirectURI: String = infoDictionary["API_REDIRECT_URI"] as? String else {
            fatalError("Missing API_REDIRECT_URI in Info.plist")
        }
        
        return redirectURI
    }
}
