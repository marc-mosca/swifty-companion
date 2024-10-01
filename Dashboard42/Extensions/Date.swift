//
//  Date.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

extension Date {
    
    static func duration(from start: Date, to end: Date) -> LocalizedStringKey {
        let dateComponents = Calendar.current.dateComponents([.minute, .hour, .day], from: start, to: end)
        
        switch (dateComponents.day, dateComponents.hour, dateComponents.minute) {
        case let (days?, _, _) where days > 0:
            return "\(days) days"
        case let (_, hours?, minutes?) where hours > 0 && minutes > 0:
            return "\(hours) hours \(minutes) minutes"
        case let (_, hours?, _) where hours > 0:
            return "\(hours) hours"
        case let (_, _, minutes?) where minutes > 0:
            return "\(minutes) minutes"
        default:
            return "Undefined"
        }
    }
    
}
