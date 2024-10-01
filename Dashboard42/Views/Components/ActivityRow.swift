//
//  ActivityRow.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 24/09/2024.
//

import SwiftUI

enum ActivityType {
    case info
    case project
    case event
    case exam
    case scale
    case logtime
    case achievement
    case patronage
    
    var icon: String {
        switch self {
        case .info: "info.circle"
        case .project: "folder"
        case .event: "megaphone"
        case .exam: "book.closed"
        case .scale: "pencil.and.outline"
        case .logtime: "clock"
        case .achievement: "rosette"
        case .patronage: "person.2"
        }
    }
    
    var color: Color {
        switch self {
        case .info: .gray
        case .project: .indigo
        case .event: .cyan
        case .exam: .blue
        case .scale: .purple
        case .logtime: .teal
        case .achievement: .brown
        case .patronage: .pink
        }
    }
}

struct ActivityRow<T: View>: View {
    let type: ActivityType
    let title: LocalizedStringKey
    let description: String?
    let destination: AnyView?
    
    init(activity: Activities) {
        self.type = activity.type
        self.title = activity.title
        self.description = activity.description
        self.destination = activity.hasDestination ? AnyView(activity.destination) : nil
    }
    
    init(type: ActivityType, title: LocalizedStringKey, description: String? = nil, destination: T) {
        self.type = type
        self.title = title
        self.description = description
        self.destination = AnyView(destination)
    }
    
    var body: some View {
        if let destination {
            NavigationLink(destination: destination) {
                activityLabel
            }
        }
        else {
            activityLabel
        }
    }
    
    @ViewBuilder
    private var activityLabel: some View {
        HStack(spacing: 16) {
            Image(systemName: type.icon)
                .imageScale(.large)
                .foregroundStyle(type.color.gradient)
            
            VStack(alignment: .leading) {
                Text(title)
                
                if let description {
                    Text(description)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(height: 40, alignment: .leading)
    }
}

#Preview {
    ActivityRow(type: .project, title: "swifty-companion", description: "42cursus - Finished", destination: EmptyView())
        .padding()
}
