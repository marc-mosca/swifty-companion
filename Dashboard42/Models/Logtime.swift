//
//  Logtime.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 04/10/2024.
//

import SwiftUI

typealias LogtimeResult = [String: String]

struct Logtime: Identifiable {
    let month: String
    let total: Double
    let details: LogtimeResult
    let workingDays: Double
    
    var id: UUID { .init() }
    
    var year: Int {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let date: Date = dateFormatter.date(from: month)!
        let calendar: Calendar = .current
        return calendar.component(.year, from: date)
    }
    
    static func organize(_ result: LogtimeResult, entryDate: String) -> [Logtime] {
        var logtimes: [Logtime] = []
        
        let calendar: Calendar = .current
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today: Date = .now
        var monthComponents: DateComponents = .init()
        monthComponents.day = 1
        
        var currentDate: Date = calendar.date(byAdding: monthComponents, to: dateFormatter.date(from: entryDate)!)!
        
        while currentDate <= today {
            let yearMonth: DateFormatter = .init()
            yearMonth.dateFormat = "MMMM yyyy"
            
            let monthKey: String = yearMonth.string(from: currentDate)
            let monthLogtime: LogtimeResult = result.filter { (key, _) in
                let logtimeDate: Date = dateFormatter.date(from: key)!
                return calendar.isDate(logtimeDate, equalTo: currentDate, toGranularity: .month)
            }
            
            let total: Double = monthLogtime.values.reduce(0.0) { $0 + convertTimeStringToHours($1) }
            let workingDays: Double = numberOfWorkingDays(in: currentDate)
            let monthlyLogtime: Logtime = .init(month: monthKey.capitalized, total: total, details: monthLogtime, workingDays: workingDays)
            
            logtimes.append(monthlyLogtime)
            currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        }
        return logtimes
    }
}

extension Logtime {
    static private func numberOfWorkingDays(in date: Date) -> Double {
        let calendar: Calendar = .current
        let range: Range<Int> = calendar.range(of: .day, in: .month, for: date)!
        
        var workingDays: Double = 0.0
        
        for day in range {
            if let dayDate = calendar.date(byAdding: .day, value: day, to: date), calendar.isDateInWeekend(dayDate) == false {
                workingDays += 1
            }
        }
        return workingDays
    }
    
    static private func convertTimeStringToHours(_ timeString: String) -> Double {
        let components = timeString.split(separator: ":").compactMap { Double($0) }
        return components.count == 3 ? components[0] + (components[1] / 60.0) + (components[2] / 3600.0) : 0.0
    }
}
