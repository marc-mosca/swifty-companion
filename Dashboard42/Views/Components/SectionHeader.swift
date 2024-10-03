//
//  SectionHeader.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct SectionHeader: View {
    let header: LocalizedStringKey
    
    var body: some View {
        Text(self.header)
            .textCase(.none)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.primary)
            .padding(.vertical)
            .listRowInsets(EdgeInsets())
    }
}

#Preview {
    SectionHeader(header: "Shortcuts")
}
