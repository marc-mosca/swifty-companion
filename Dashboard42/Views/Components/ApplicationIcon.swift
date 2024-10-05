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
    
    private let bundle: Bundle = Bundle.main
    
    init(width: CGFloat = 80, height: CGFloat = 80) {
        self.width = width
        self.height = height
    }

    private var applicationIcon: String {
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last
        else {
            fatalError("Could not find icons in bundle")
        }
        
        return iconFileName
    }
    
    var body: some View {
        Image(uiImage: .init(imageLiteralResourceName: self.applicationIcon))
            .resizable()
            .frame(width: self.width, height: self.height)
            .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ApplicationIcon()
}
