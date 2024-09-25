//
//  ApplicationTabView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import SwiftUI

struct ApplicationTabView: View {
    @Binding var selection: ApplicationScreens

    var body: some View {
        TabView(selection: $selection) {
            ForEach(ApplicationScreens.allCases) { screen in
                screen.destination
                    .tag(screen as ApplicationScreens?)
                    .tabItem { screen.label }
            }
        }
        .tint(.accent)
    }
}

#Preview {
    ApplicationTabView(selection: .constant(.home))
}
