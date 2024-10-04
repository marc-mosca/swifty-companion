//
//  Date.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

extension Date {
    static func duration(from start: Date, to end: Date) -> LocalizedStringKey {
        let calendar: Calendar = .current
        let dateComponents: DateComponents = calendar.dateComponents([.minute, .hour, .day], from: start, to: end)
        
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
    
    static func getNumberOfDaysToWorkPerMonth(_ dateStr: String) -> Double {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM"
        
        guard let date: Date = dateFormatter.date(from: dateStr) else { return 0.0 }
        
        let calendar: Calendar = .current
        let interval: DateInterval = calendar.dateInterval(of: .month, for: date)!
        var count: Double = 0.0
        var currentDate: Date = interval.start
        
        while currentDate < interval.end {
            if !calendar.isDateInWeekend(currentDate) {
                count += 1
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return count
    }
}
