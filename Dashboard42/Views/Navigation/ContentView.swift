//
//  ContentView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(Constants.userIsConnectedKey) private var userIsConnected: Bool = false

    @State var selection: ApplicationScreens = .home

    var body: some View {
        if self.userIsConnected == false {
            OnBoardingView()
                .padding()
        }
        else {
            ApplicationTabView(selection: self.$selection)
        }
    }
}

#Preview {
    ContentView()
}
