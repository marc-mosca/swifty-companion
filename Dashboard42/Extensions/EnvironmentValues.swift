//
//  EnvironmentValues.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 03/10/2024.
//

import SwiftUI

private struct AuthenticationServiceKey: EnvironmentKey {
    static let defaultValue: AuthenticationService = .init()
}

private struct CampusServiceKey: EnvironmentKey {
    static let defaultValue: CampusService = .init()
}

private struct UserServiceKey: EnvironmentKey {
    static let defaultValue: UserService = .init()
}

extension EnvironmentValues {
    var authenticationService: AuthenticationService {
        get { self[AuthenticationServiceKey.self] }
        set { self[AuthenticationServiceKey.self] = newValue }
    }
    
    var campusService: CampusService {
        get { self[CampusServiceKey.self] }
        set { self[CampusServiceKey.self] = newValue }
    }
    
    var userService: UserService {
        get { self[UserServiceKey.self] }
        set { self[UserServiceKey.self] = newValue }
    }
}
