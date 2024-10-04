//
//  ContentView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 06/05/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.campusService) private var campusService: CampusService
    @Environment(\.userService) private var userService: UserService
    
    @AppStorage(Constants.userIsConnectedKey) private var userIsConnected: Bool = false

    @State var selection: ApplicationScreens = .home
    
    @State private var isLoading: Bool = false
    @State private var isFirstLoad: Bool = true
    
    @State private var error: Dashboard42UIErrors? = nil
    @State private var hasError: Bool = false

    var body: some View {
        if self.userIsConnected == false {
            OnBoardingView()
                .padding()
        }
        else {
            VStack {
                if self.isLoading == true {
                    ProgressView("Loading...")
                }
                else if self.hasError == true {
                    Text("Error")
                }
                else {
                    ApplicationTabView(selection: self.$selection)
                }
            }
            .error(isPresented: self.$hasError, error: self.error)
            .task {
                guard self.isFirstLoad == true else { return }
                await self.fetch()
            }
        }
    }
    
    private func fetch() async -> Void {
        self.isLoading = true
        
        do {
            try await self.userService.fetchConnectedUser()
            
            guard let user: User = self.userService.user else { return }
            
            try await self.userService.fetchEvents(userId: user.id)
            try await self.userService.fetchExams(userId: user.id)
            try await self.userService.fetchScales()
            try await self.userService.fetchLogtimes(login: user.login, entryDate: user.entryDate)
        }
        catch {
            self.error = .cannotFetchUserInformations
            self.hasError = true
        }
        
        do {
            guard let user: User = self.userService.user else { return }
            guard let campusId: Int = user.mainCampus?.campusId else { return }
            guard let cursusId: Int = user.mainCursus?.cursusId else { return }
            
            try await self.campusService.fetchEvents(campusId: campusId, cursusId: cursusId)
            try await self.campusService.fetchExams(campusId: campusId)
        }
        catch {
            self.error = .cannotFetchCampusActivities
            self.hasError = true
        }
        
        self.isFirstLoad = false
        self.isLoading = false
    }
}

#Preview {
    ContentView()
}
