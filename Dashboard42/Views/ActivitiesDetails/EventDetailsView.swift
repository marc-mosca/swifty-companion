//
//  EventDetailsView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct EventDetailsView: View {
    @Environment(UserService.self) private var userService
    @State private var presentDialog = false
    
    let event: Event
    
    private var isSubscribe: Bool { userService.events.contains(where: { $0.id == event.id }) }
    private var isSubscribeFormatted: LocalizedStringKey { isSubscribe ? "Yes" : "No" }
    private var dialogButtonTitle: LocalizedStringKey { isSubscribe ? "Unregister" : "Register" }
    
    private var date: String {
        event.beginAt.formatted(.dateTime.weekday(.wide).day(.twoDigits).month(.wide).year().hour().minute())
    }
    
    private var dialogTitle: LocalizedStringKey {
        isSubscribe ? "Are you sure you want to register for this event?" : "Are you sure you want to unregister for this event?"
    }

    var body: some View {
        List {
            Section("Informations") {
                HRow(title: "Date", value: date.localizedCapitalized)
                HRow(title: "Duration", value: Date.duration(from: event.beginAt, to: event.endAt))
                HRow(title: "Registered", value: isSubscribeFormatted)
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
                Button(dialogButtonTitle, action: { presentDialog.toggle() })
            }
        }
        .confirmationDialog(dialogTitle, isPresented: $presentDialog) {
            Button(dialogButtonTitle, action: handleDialogButtonTapped)
        }
    }
    
    private func handleDialogButtonTapped() {
        guard let user = userService.user else { return }
        
        Task {
            do {
                if isSubscribe {
                    try await userService.unregisterEvent(userId: user.id, eventId: event.id)
                }
                else {
                    try await userService.registerEvent(userId: user.id, eventId: event.id)
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
