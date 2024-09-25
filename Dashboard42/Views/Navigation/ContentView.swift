//
//  ContentView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(Constants.userIsConnectedKey) private var userIsConnected: Bool?
    @State private var selection = ApplicationScreens.home

    var body: some View {
        if userIsConnected != true {
            OnBoardingView()
                .padding()
        }
        else {
            ApplicationTabView(selection: $selection)
        }
    }
}

#Preview {
    ContentView()
        .environment(AuthenticationService())
}
