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
    let numberOfDaysToWork: Double
    
    var id: UUID { .init() }
    
    var fullmonth: LocalizedStringKey {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM"
        dateFormatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: Constants.applicationLanguageKey) ?? "en")
        
        guard let date: Date = dateFormatter.date(from: month) else { return "Undefined" }
        
        dateFormatter.dateFormat = "MMMM yyyy"
        return "\(dateFormatter.string(from: date).capitalized)"
    }
}
