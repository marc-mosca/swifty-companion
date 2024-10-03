//
//  Activities.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import SwiftUI

enum Activities: Identifiable {
    case project(User.Projects)
    case exam(Exam)
    case scale(Scale)
    case event(Event)
    
    private var formatter: Date.FormatStyle {
        return .dateTime.weekday(.wide).day(.twoDigits).month(.wide).year().hour().minute()
    }
    
    var id: Int {
        switch self {
        case .project(let project): return project.id
        case .exam(let exam): return exam.id
        case .scale(let scale): return scale.id
        case .event(let event): return event.id
        }
    }
    
    var type: ActivityType {
        switch self {
        case .project: return .project
        case .exam: return .exam
        case .scale: return .scale
        case .event: return .event
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .project(let project): return "\(project.project.name)"
        case .exam(let exam): return "\(exam.name)"
        case .scale(let scale): return scale.corrector != nil ? "Scale \(scale.corrector!.login)" : "Scale"
        case .event(let event): return  "\(event.name)"
        }
    }
    
    var description: String? {
        let date: Date?

        switch self {
        case .project(let project): date = project.markedAt
        case .exam(let exam): date = exam.beginAt
        case .scale(let scale): date = scale.beginAt
        case .event(let event): date = event.beginAt
        }
        
        return date?.formatted(formatter).capitalized ?? nil
    }
    
    var beginAt: Date {
        switch self {
        case .project(let project): return project.markedAt ?? Date()
        case .exam(let exam): return exam.beginAt
        case .scale(let scale): return scale.beginAt
        case .event(let event): return event.beginAt
        }
    }
    
    var beginAtFormatted: String {
        return beginAt.formatted(.dateTime.year().month(.wide))
    }
}

struct GroupedActivities: Identifiable {
    let monthYear: String
    let activities: [Activities]
    
    var id: String { monthYear }
    
    enum OrderBy {
        case ASC
        case DESC
    }
    
    static func create(for activities: [Activities], order: OrderBy) -> [GroupedActivities] {
        let groupedActivities: [String: [Activities]] = Dictionary(grouping: activities, by: \.beginAtFormatted)
        let sortedGroups: [Dictionary<String, [Activities]>.Element] = groupedActivities.sorted { lhs, rhs in
            guard let lhsDate = lhs.value.first?.beginAt, let rhsDate = rhs.value.first?.beginAt else { return false }
            return order == .ASC ? lhsDate < rhsDate : lhsDate > rhsDate
        }
        return sortedGroups.map { GroupedActivities(monthYear: $0.key, activities: $0.value) }
    }
}
