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

struct ActivityRow: View {
    let type: ActivityType
    let title: String
    let description: String?
    
    var body: some View {
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
    ActivityRow(type: .project, title: "swifty-companion", description: "42cursus - Finished")
        .padding()
}
