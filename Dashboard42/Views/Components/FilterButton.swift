//
//  FilterButton.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct FilterButton: View {
    @Binding var selectedFilter: String
    let filters: [String]
    
    var body: some View {
        Menu("Filter activities", systemImage: "line.3.horizontal.decrease.circle") {
            Picker("Select a filter", selection: Binding($selectedFilter, deselectTo: "")) {
                ForEach(filters, id: \.self) { filter in
                    Text(filter)
                }
            }
        }
    }
}

#Preview {
    FilterButton(selectedFilter: .constant(""), filters: ["Foo", "Bar"])
}
