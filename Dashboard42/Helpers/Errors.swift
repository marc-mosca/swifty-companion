//
//  Errors.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 22/09/2024.
//

import SwiftUI

enum Dashboard42Errors: Error {
    case decodingError
    case invalidAccessToken
    case tooManyRequests
    case serverError
    
    case runtimeError(String)
}

enum Dashboard42UIErrors: Error {
    case cannotLinkAccount
    case cannotFetchUserInformations
    case cannotFetchCampusActivities
    case cannotRegisterEvent
    case cannotUnregisterEvent
    case userNotFound
    
    var title: LocalizedStringKey {
        switch self {
        case .cannotLinkAccount: return "Error: Cannot link your 42 account"
        case .cannotFetchUserInformations: return "Error: Cannot fetch user information"
        case .cannotFetchCampusActivities: return "Error: Cannot fetch campus activities"
        case .cannotRegisterEvent: return "Error: Cannot register event"
        case .cannotUnregisterEvent: return "Error: Cannot unregister event"
        case .userNotFound: return "Error: User not found"
        }
    }
    
    var description: LocalizedStringKey {
        switch self {
        case .cannotLinkAccount: return "Cannot link your 42 account. Please check your internet connection and try again."
        case .cannotFetchUserInformations: return "Cannot fetch user information. Please check your internet connection and try again."
        case .cannotFetchCampusActivities: return "Cannot fetch campus activities. Please check your internet connection and try again."
        case .cannotRegisterEvent: return "Cannot register event. Please check your internet connection and try again."
        case .cannotUnregisterEvent: return "Cannot unregister event. Please check your internet connection and try again."
        case .userNotFound: return "The search for the user was unsuccessful. Please check the login and try again."
        }
    }
}
