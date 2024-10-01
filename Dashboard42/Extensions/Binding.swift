//
//  Binding.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

extension Binding where Value: Equatable {
    init(_ source: Binding<Value>, deselectTo value: Value) {
        self.init(
            get: { source.wrappedValue },
            set: { source.wrappedValue = $0 == source.wrappedValue ? value : $0 }
        )
    }
}
