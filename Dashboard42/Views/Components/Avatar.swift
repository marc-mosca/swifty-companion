//
//  Avatar.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct Avatar: View {
    let url: String
    let isAvailable: Bool
    
    var body: some View {
        AsyncImage(url: URL(string: self.url)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.gray
        }
        .frame(width: 100, height: 100)
        .clipShape(.circle)
        .padding(3)
        .overlay {
            Circle()
                .fill(.clear)
                .stroke(self.isAvailable ? .green.opacity(0.7) : .gray.opacity(0.5), lineWidth: 2)
        }
        .frame(width: 100, height: 100)
    }
}

#Preview {
    Avatar(url: "", isAvailable: true)
}
