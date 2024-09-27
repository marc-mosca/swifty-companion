//
//  Activities.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 27/09/2024.
//

import Foundation

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
        case .event: .event(isSubscribe: false)
        }
    }
    
    var title: String {
        switch self {
        case .project(let project): project.project.name
        case .exam(let exam): exam.name
        case .scale: "Scale"
        case .event(let event): event.name
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
        case .project(let project): project.markedAt ?? Date()
        case .exam(let exam): exam.beginAt
        case .scale(let scale): scale.beginAt
        case .event(let event): event.beginAt
        }
    }
}
