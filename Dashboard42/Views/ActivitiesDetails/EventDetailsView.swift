//
//  EventDetailsView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct EventDetailsView: View {
    @Environment(\.userService) private var userService: UserService
    
    @State private var isLoading: Bool = false
    
    @State private var error: Dashboard42UIErrors? = nil
    @State private var hasError: Bool = false
    
    @State private var presentDialog: Bool = false
    
    let event: Event
    
    private var isSubscribe: Bool { self.userService.events.contains(where: { $0.id == event.id }) }
    private var isSubscribeFormatted: LocalizedStringKey { self.isSubscribe ? "Yes" : "No" }
    private var dialogButtonTitle: LocalizedStringKey { self.isSubscribe ? "Unregister" : "Register" }
    
    private var date: String {
        self.event.beginAt.formatted(.dateTime.weekday(.wide).day(.twoDigits).month(.wide).year().hour().minute())
    }
    
    private var dialogTitle: LocalizedStringKey {
        self.isSubscribe ? "Are you sure you want to register for this event?" : "Are you sure you want to unregister for this event?"
    }

    var body: some View {
        List {
            Section("Informations") {
                HRow(title: "Date", value: self.date.localizedCapitalized)
                HRow(title: "Duration", value: Date.duration(from: self.event.beginAt, to: self.event.endAt))
                HRow(title: "Registered", value: self.isSubscribeFormatted)
                HRow(title: "Participants", value: self.event.nbrSubscribers.formatted())
                HRow(title: "Location", value: self.event.location)
            }
            
            Section("Description") {
                Text(self.event.description)
            }
        }
        .navigationTitle(self.event.name)
        .navigationBarTitleDisplayMode(.inline)
        .error(isPresented: self.$hasError, error: self.error)
        .toolbar {
            if self.event.beginAt > .now {
                Button(self.dialogButtonTitle) {
                    self.presentDialog = true
                }
            }
        }
        .confirmationDialog(self.dialogTitle, isPresented: self.$presentDialog) {
            Button(self.dialogButtonTitle) {
                self.handleDialogButtonTapped()
            }
        }
    }
    
    private func handleDialogButtonTapped() -> Void {
        guard let user: User = self.userService.user else { return }
        
        Task {
            self.isLoading = true
            
            do {
                if self.isSubscribe == true {
                    try await self.userService.deleteEvent(userId: user.id, eventId: self.event.id)
                }
                else {
                    try await self.userService.updateEvent(userId: user.id, eventId: self.event.id)
                }
            }
            catch {
                self.error = self.isSubscribe == true ? .cannotUnregisterEvent : .cannotRegisterEvent
                self.hasError = true
            }
            
            self.isLoading = false
        }
    }
}
