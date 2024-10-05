//
//  HRow.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct HRow: View {
    let title: LocalizedStringKey
    let value: LocalizedStringKey
    
    init(title: LocalizedStringKey, value: String) {
        self.title = title
        self.value = "\(value)"
    }
    
    init(title: LocalizedStringKey, value: LocalizedStringKey) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        HStack {
            Text(self.title)
                .foregroundStyle(.primary)
                .padding(.trailing, 10)
            
            Spacer()
            
            Text(self.value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .font(.subheadline)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    HRow(title: "Foo", value: "bar")
}
