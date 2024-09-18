//
//  AuthenticationService.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 17/09/2024.
//

import Foundation

@Observable
class AuthenticationService {
    private(set) var userTokens: AuthenticationUserToken?
    private(set) var applicationTokens: AuthenticationApplicationToken?
    
    init() { }
    
    func signIn() {
        print("AuthenticationService: Sign In")
    }
}
