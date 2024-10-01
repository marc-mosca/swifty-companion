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
        .dateTime.weekday(.wide).day(.twoDigits).month(.wide).year().hour().minute()
    }
    
    var id: Int {
        switch self {
        case .project(let project): project.id
        case .exam(let exam): exam.id
        case .scale(let scale): scale.id
        case .event(let event): event.id
        }
    }
    
    var type: ActivityType {
        switch self {
        case .project: .project
        case .exam: .exam
        case .scale: .scale
        case .event: .event
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .project(let project): "\(project.project.name)"
        case .exam(let exam): "\(exam.name)"
        case .scale(let scale): scale.corrector != nil ? "Scale \(scale.corrector!.login)" : "Scale"
        case .event(let event): "\(event.name)"
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
    
    var hasDestination: Bool {
        switch self {
        case .event, .exam: true
        default: false
        }
    }
    
    @ViewBuilder
    var destination: some View {
        if case .event(let event) = self {
            EventDetailsView(event: event)
        }
        else if case .exam(let exam) = self {
            ExamDetailsView(exam: exam)
        }
    }
    
    var beginAt: Date {
        switch self {
        case .project(let project): project.markedAt ?? Date()
        case .exam(let exam): exam.beginAt
        case .scale(let scale): scale.beginAt
        case .event(let event): event.beginAt
        }
    }
    
    var beginAtFormatted: String {
        beginAt.formatted(.dateTime.year().month(.wide))
    }
}

struct GroupedActivities: Identifiable {
    let monthYear: String
    let activities: [Activities]
    
    var id: String { monthYear }
    
    static func create(for activities: [Activities], asc: Bool = true) -> [GroupedActivities] {
        let dictionary = Dictionary(grouping: activities, by: \.beginAtFormatted)
        let sortedKey = dictionary.keys.sorted { lhs, rhs in
            let lhsActivity = activities.first(where: { $0.beginAtFormatted == lhs })
            let rhsActivity = activities.first(where: { $0.beginAtFormatted == rhs })
            
            guard let lhsDate = lhsActivity?.beginAt, let rhsDate = rhsActivity?.beginAt else { return false }
            return asc ? lhsDate < rhsDate : lhsDate > rhsDate
        }
        return sortedKey.compactMap { GroupedActivities(monthYear: $0, activities: dictionary[$0] ?? []) }
    }
}
