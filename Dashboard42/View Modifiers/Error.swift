//
//  Error.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 03/10/2024.
//

import SwiftUI

struct ErrorViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let error: Dashboard42UIErrors?
    
    func body(content: Content) -> some View {
        if let error: Dashboard42UIErrors = error {
            content
                .alert(error.title, isPresented: $isPresented) {
                    Button("OK", role: .cancel, action: { })
                } message: {
                    Text(error.description)
                }
        }
        else {
            content
        }
    }
}

extension View {
    func error(isPresented: Binding<Bool>, error: Dashboard42UIErrors?) -> some View {
        modifier(ErrorViewModifier(isPresented: isPresented, error: error))
    }
}
