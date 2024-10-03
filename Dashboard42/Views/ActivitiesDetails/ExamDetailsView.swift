//
//  ExamDetailsView.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 01/10/2024.
//

import SwiftUI

struct ExamDetailsView: View {
    let exam: Exam
    
    private var date: String {
        self.exam.beginAt.formatted(.dateTime.weekday(.wide).day(.twoDigits).month(.wide).year().hour().minute())
    }

    var body: some View {
        List {
            Section("Informations") {
                HRow(title: "Date", value: self.date.localizedCapitalized)
                HRow(title: "Duration", value: Date.duration(from: self.exam.beginAt, to: self.exam.endAt))
                HRow(title: "Participants", value: self.exam.nbrSubscribers.formatted())
                HRow(title: "Location", value: self.exam.location)
            }
            
            Section("Related Projects") {
                ForEach(self.exam.projects) { project in
                    Text(project.name)
                }
            }
        }
        .navigationTitle(self.exam.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
