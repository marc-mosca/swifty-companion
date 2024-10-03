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
        case .info: return "info.circle"
        case .project: return "folder"
        case .event: return "megaphone"
        case .exam: return "book.closed"
        case .scale: return "pencil.and.outline"
        case .logtime: return "clock"
        case .achievement: return "rosette"
        case .patronage: return "person.2"
        }
    }
    
    var color: Color {
        switch self {
        case .info: return .gray
        case .project: return .indigo
        case .event: return .cyan
        case .exam: return .blue
        case .scale: return .purple
        case .logtime: return .teal
        case .achievement: return .brown
        case .patronage: return .pink
        }
    }
}

struct ActivityRow: View {
    let type: ActivityType
    let title: LocalizedStringKey
    let description: String?
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: self.type.icon)
                .imageScale(.large)
                .foregroundStyle(self.type.color.gradient)
            
            VStack(alignment: .leading) {
                Text(self.title)
                
                if let description = self.description {
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
