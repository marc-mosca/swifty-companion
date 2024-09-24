//
//  ContentView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(Constants.userIsConnectedKey) private var userIsConnected: Bool?

    var body: some View {
        if userIsConnected != true {
            OnBoardingView()
                .padding()
        }
        else {
            ProgressView()
        }
    }
}

#Preview {
    ContentView()
}
