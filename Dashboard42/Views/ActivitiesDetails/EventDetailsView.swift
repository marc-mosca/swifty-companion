//
//  EventDetailsView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct EventDetailsView: View {
    @Environment(UserService.self) private var userService
    
    let event: Event
    
    private var date: String {
        event.beginAt.formatted(.dateTime.weekday(.wide).day(.twoDigits).month(.wide).year().hour().minute())
    }
    
    private var isSubscribe: Bool { userService.events.contains(where: { $0.id == event.id }) }
    private var isSubscribeFormatted: LocalizedStringKey { isSubscribe ? "Yes" : "No" }

    var body: some View {
        List {
            Section("Informations") {
                HRow(title: "Date", value: date.localizedCapitalized)
                HRow(title: "Duration", value: Date.duration(from: event.beginAt, to: event.endAt))
                HRow(title: "Register", value: isSubscribeFormatted)
                HRow(title: "Participants", value: event.nbrSubscribers.formatted())
                HRow(title: "Location", value: event.location)
            }
            
            Section("Description") {
                Text(event.description)
            }
        }
        .navigationTitle(event.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if event.beginAt > .now {
                Button("Register") {
                    print("Register")
                }
            }
        }
    }
}
