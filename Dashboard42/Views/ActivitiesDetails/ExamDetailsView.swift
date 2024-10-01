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
        exam.beginAt.formatted(.dateTime.weekday(.wide).day(.twoDigits).month(.wide).year().hour().minute())
    }

    var body: some View {
        List {
            Section("Informations") {
                HRow(title: "Date", value: date.localizedCapitalized)
                HRow(title: "Duration", value: Date.duration(from: exam.beginAt, to: exam.endAt))
                HRow(title: "Participants", value: exam.nbrSubscribers.formatted())
                HRow(title: "Location", value: exam.location)
            }
            
            Section("Related Projects") {
                ForEach(exam.projects) { project in
                    Text(project.name)
                }
            }
        }
        .navigationTitle(exam.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
