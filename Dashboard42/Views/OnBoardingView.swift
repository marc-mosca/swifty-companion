//
//  OnBoardingView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 17/09/2024.
//

import AuthenticationServices
import SwiftUI

struct OnBoardingView: View {
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession: WebAuthenticationSession
    @Environment(\.authenticationService) private var authenticationService: AuthenticationService
    
    @AppStorage(Constants.userIsConnectedKey) private var userIsConnected: Bool?
    
    @State private var error: Dashboard42UIErrors? = nil
    @State private var hasError: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            ApplicationIcon()
            
            VStack(alignment: .leading) {
                Text("Welcome to")
                Text("Dashboard42")
                    .foregroundStyle(.accent)
            }
            .font(.largeTitle)
            .fontWeight(.heavy)
            
            Text("An application developed by a student for the student community of 42.")
                .font(.subheadline)
            
            Spacer()
            Spacer()
            
            Button(action: signInButtonTapped) {
                Text("Sign In")
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            .background(.accent)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 10))
        }
    }
    
    private func signInButtonTapped() -> Void {
        guard let authenticationURL: URL = authenticationService.authenticationURL else { return }
        guard let callbackURL: String = Constants.redirectURI.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        Task {
            do {
                let urlWithToken: URL = try await webAuthenticationSession.authenticate(
                    using: authenticationURL,
                    callbackURLScheme: callbackURL
                )
                try await authenticationService.signIn(url: urlWithToken)
                userIsConnected = true
            }
            catch {
                self.error = .cannotLinkAccount
                self.hasError = true
            }
        }
    }
}

#Preview {
    OnBoardingView()
        .padding()
}
