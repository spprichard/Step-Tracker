//
//  StepPieChart.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-19.
//

import Charts
import SwiftUI

struct StepPieChart: View {
    var chartData: [WeekDayChartData]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Label("Averages", systemImage: "calendar")
                    .font(.title3.bold())
                    .foregroundStyle(.pink)
                
                Text("Last 28 Days")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 12)
            
            Chart {
                ForEach(chartData) { weekDay in
                    SectorMark(
                        angle: .value("Average Steps", weekDay.value),
                        innerRadius: .ratio(0.618),
                        angularInset: 1
                    )
                    .foregroundStyle(.pink.gradient)
                    .cornerRadius(4)
                }
            }.frame(height: 240)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekDayCount(for: HealthMetric.mockData))
}
