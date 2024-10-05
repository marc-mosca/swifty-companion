//
//  UserLogtimes.swift
//  Dashboard42
//
//  Created by Marc MOSCA on 05/10/2024.
//

import Charts
import SwiftUI

struct UserLogtimes: View {
    @Environment(\.userService) private var userService: UserService
    
    @State private var selectedFilter: String = ""
    
    private var filters: [String] { Set(self.userService.logtimes.map { String($0.year) }).sorted() }
    
    private var filteredLogtimes: [Logtime] {
        let logtimes: [Logtime] = self.userService.logtimes.reversed()
        return self.selectedFilter == "" ? logtimes : logtimes.filter { String($0.year) == self.selectedFilter }
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filteredLogtimes) { logtime in
                        VStack {
                            GroupBox {
                                LogtimeChart(month: logtime.month, logtime: logtime.total, workingDays: logtime.workingDays)
                            } label: {
                                HStack {
                                    Label(logtime.month, systemImage: "clock")
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            
                            HStack {
                                GroupBox("Online") {
                                    Text("\(logtime.details.count) days")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                
                                GroupBox("Total") {
                                    Text("\(String(format: "%.2f", logtime.total)) hours")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                                
                                GroupBox("Average") {
                                    let average = logtime.total == 0 || logtime.details.count == 0 ? 0 : logtime.total / Double(logtime.details.count)
                                    
                                    Text("\(String(format: "%.2f", average)) hours")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.paging)
        }
        .navigationTitle("Logtimes")
        .toolbar {
            ToolbarItem {
                FilterButton(selectedFilter: self.$selectedFilter, filters: self.filters)
            }
        }
    }
}

extension UserLogtimes {
    private struct LogtimeChart: View {
        let month: String
        let logtime: Double
        let workingDays: Double
        
        private var timeToWork: Double { workingDays * 7 }
        
        private var logtimeChartData: [(type: String, time: Double)] {
            [
                (type: month, time: logtime),
                (type: "default", time: timeToWork - logtime < 0 ? 0 : timeToWork - logtime)
            ]
        }
        
        var body: some View {
            Chart(logtimeChartData, id: \.type) {
                SectorMark(
                    angle: .value("Value", $1),
                    innerRadius: .ratio(0.618),
                    outerRadius: .inset(10),
                    angularInset: 1
                )
                .cornerRadius(8)
                .foregroundStyle(.accent.gradient)
                .opacity($0 == "default" ? 0.5 : 1)
            }
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    
                    VStack {
                        Text("Goal")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(logtime / timeToWork, format: .percent.precision(.fractionLength(2)))
                            .foregroundStyle(.secondary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                    .font(.callout)
                }
            }
        }
    }
}
