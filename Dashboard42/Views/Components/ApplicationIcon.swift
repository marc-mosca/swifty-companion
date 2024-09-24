//
//  ApplicationIcon.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import SwiftUI

struct ApplicationIcon: View {
    let width: CGFloat
    let height: CGFloat
    
    init(width: CGFloat = 80, height: CGFloat = 80) {
        self.width = width
        self.height = height
    }

    private var appIcon: String {
        guard let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }
        
        return iconFileName
    }
    
    var body: some View {
        Image(uiImage: .init(imageLiteralResourceName: appIcon))
            .resizable()
            .frame(width: width, height: height)
            .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ApplicationIcon()
}
