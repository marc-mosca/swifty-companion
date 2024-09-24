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
    case event(isSubscribe: Bool)
    case scale
    case logtime
    case achievement
    case patronage
    
    var icon: String {
        switch self {
        case .info: "info.circle"
        case .project: "folder"
        case .event: "megaphone"
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
        case .event(let isSubscribe): isSubscribe ? .green : .cyan
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
                .foregroundStyle(type.color)
            
            VStack(alignment: .leading) {
                Text(title)

                if let description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(height: 50, alignment: .leading)
    }
}

#Preview {
    ActivityRow(type: .project, title: "swifty-companion", description: "42cursus - Finished")
        .padding()
}
