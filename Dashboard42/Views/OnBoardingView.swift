//
//  OnBoardingView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 17/09/2024.
//

import SwiftUI

struct OnBoardingView: View {
    var appIcon: String {
        guard let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }
        
        return iconFileName
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()
            
            Image(uiImage: .init(imageLiteralResourceName: appIcon))
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(.rect(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                Text("Welcome to")
                Text("Dashboard42")
                    .foregroundStyle(.accent)
            }
            .font(.system(size: 34))
            .fontWeight(.heavy)
            
            Text("An application developed by a student for the student community of 42.")
                .font(.subheadline)
            
            Spacer()
            Spacer()
            
            Button(action: signInButtonTapped) {
                Text("Sign In")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding()
            }
            .background(.accent)
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 10))
            .fontWeight(.medium)
        }
    }
    
    private func signInButtonTapped() {
        print("Sign In Button Tapped!")
    }
}

#Preview {
    OnBoardingView()
        .padding()
}
