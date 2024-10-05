//
//  UserCorrections.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/10/2024.
//

import SwiftUI

struct UserCorrections: View {
    @Environment(\.userService) private var userService: UserService
    
    @State private var isLoading: Bool = false
    
    @State private var error: Dashboard42UIErrors? = nil
    @State private var hasError: Bool = false
    
    @State private var showSheet: Bool = false
    
    private var slotsAvailable: [GroupedSlot] { GroupedSlot.create(for: self.userService.slots.filter({ $0.scaleTeam == nil })) }
    private var slotsUnavailable: [GroupedSlot] { GroupedSlot.create(for: self.userService.slots.filter({ $0.scaleTeam != nil })) }
    private var scales: [Activities] { self.userService.scales.map { Activities.scale($0) } }
    
    var body: some View {
        VStack {
            if self.isLoading == true {
                ProgressView()
            }
            else {
                List {
                    if self.scales.isEmpty == false {
                        Section("Scales") {
                            ForEach(self.scales) {
                                ActivityRow(type: .scale, title: $0.title, description: $0.description)
                            }
                        }
                    }
                    
                    if slotsUnavailable.isEmpty == false {
                        Section("Slot taken by a scale") {
                            ForEach(slotsUnavailable) { slot in
                                SlotRow(slot: slot)
                            }
                        }
                    }
                    
                    if slotsAvailable.isEmpty == false {
                        Section("Slot available for a scale") {
                            ForEach(slotsAvailable) { slot in
                                SlotRow(slot: slot)
                            }
                            .onDelete(perform: self.onDelete)
                        }
                    }
                }
            }
        }
        .navigationTitle("Scales")
        .error(isPresented: self.$hasError, error: self.error)
        .overlay {
            if self.scales.isEmpty == true && self.slotsAvailable.isEmpty == true && self.slotsUnavailable.isEmpty == true {
                ContentUnavailableView {
                    Label("No correction slots found", systemImage: "pencil.and.outline")
                } description: {
                    Text("Create a correction slot to see it appear in the list.")
                } actions: {
                    Button("Create a correction slot") {
                        self.showSheet = true
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Create a correction slot", systemImage: "plus") {
                    self.showSheet = true
                }
            }
        }
        .sheet(isPresented: self.$showSheet) {
            CorrectionSheet(showSheet: self.$showSheet)
        }
    }
    
    private func onDelete(_ indexSet: IndexSet) -> Void {
        Task {
            self.isLoading = true

            for index in indexSet {
                guard self.slotsAvailable.count > index else { return }
                
                for slot in slotsAvailable[index].slots {
                    guard slot.scaleTeam == nil else { return }
                }
                
                for slotId in slotsAvailable[index].slotsIds {
                    do {
                        try await self.userService.deleteSlot(slotId: slotId)
                    }
                    catch {
                        self.error = .cannotUnregisterSlot
                        self.hasError = true
                    }
                }
            }
            
            do {
                try await self.userService.fetchSlots()
            }
            catch {
                self.error = .cannotFetchSlots
                self.hasError = true
            }
            
            self.isLoading = false
        }
    }
}

extension UserCorrections {
    private struct SlotRow: View {
        let slot: GroupedSlot
        
        private var isSameDay: Bool { self.slot.beginAt != self.slot.endAt }
        private var duration: LocalizedStringKey { Date.duration(from: self.slot.beginAt, to: self.slot.endAt) }
        
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: "pencil.and.outline")
                    .imageScale(.large)
                    .foregroundStyle(.purple.gradient)
                
                VStack(alignment: .leading) {
                    Text("Slot")
                    
                    HStack {
                        Text(self.slot.beginAt, format: .dateTime.weekday(.wide).day(.twoDigits).month(.wide).year().hour().minute())
                        Text(duration)
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .frame(height: 40, alignment: .leading)
        }
    }
    
    private struct CorrectionSheet: View {
        @Environment(\.userService) private var userService: UserService
        
        @Binding var showSheet: Bool
        
        @State private var defaultBeginAt: Date = .init(timeIntervalSinceNow: 3_600)
        @State private var defaultEndBeginAt: Date = .init(timeIntervalSinceNow: 1_200_600)
        @State private var defaultEndAt: Date = .init(timeIntervalSinceNow: 1_204_200)
        @State private var beginAt: Date = .init(timeIntervalSinceNow: 3_600)
        @State private var endAt: Date = .init(timeIntervalSinceNow: 7_200)
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 10) {
                    Text("A slot is an interval of time during which you declare yourself available to assess other students. A time slot can be defined between 45 minutes and 2 weeks in advance, and must last at least one hour.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                        .padding(.horizontal, 14)
                    
                    VStack {
                        DatePicker("Start", selection: self.$beginAt, in: self.defaultBeginAt ... self.defaultEndBeginAt)
                        DatePicker(
                            "End",
                            selection: self.$endAt,
                            in: Date(timeInterval: 3_600, since: self.beginAt) ... self.defaultEndAt
                        )
                    }
                    .onChange(of: self.beginAt, self.onBeginAtChange)
                    .padding()
                    
                    Spacer()
                }
                .navigationTitle("Create a correction slot")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) { self.showSheet = false }
                    }
                    
                    ToolbarItem {
                        Button("Create", action: self.createSlot)
                    }
                }
            }
            .onAppear { UIDatePicker.appearance().minuteInterval = 15 }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        
        private func createSlot() -> Void {
            guard Date.now < self.beginAt else { return }
            guard self.beginAt < self.endAt else { return }
            guard let user: User = self.userService.user else { return }
            guard let difference: Int = Calendar.current.dateComponents([.hour], from: self.beginAt, to: self.endAt).hour, difference >= 1 else { return }
            
            Task {
                do {
                    try await self.userService.updateSlot(userId: user.id, beginAt: self.beginAt, endAt: self.endAt)
                    try await self.userService.fetchSlots()
                }
                catch {
                    print(error)
                }
            }
            self.showSheet = false
        }
        
        private func onBeginAtChange() -> Void {
            let date: Date = .init(timeInterval: 3_600, since: self.beginAt)
            
            guard let difference: Int = Calendar.current.dateComponents([.hour], from: self.beginAt, to: self.endAt).hour, difference <= 1 else { return }
            
            if date < self.defaultEndAt {
                self.endAt = date
            }
        }
    }
}
