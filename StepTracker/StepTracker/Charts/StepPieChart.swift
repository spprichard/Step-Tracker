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
    
    private var selectedWeekDay: WeekDayChartData? {
        guard let rawSelectedChartValue else { return nil }
        var total = 0.0
        
        return chartData.first {
            total += $0.value
            return total >= rawSelectedChartValue
        }
    }
    
    @State
    private var rawSelectedChartValue: Double?
    
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
                    .opacity(selectedWeekDay?.date.weekDayInt == weekDay.date.weekDayInt ? 1.0 : 0.3)
                }
            }
            .frame(height: 240)
            .chartAngleSelection(value: $rawSelectedChartValue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
        .onChange(of: rawSelectedChartValue) {
            print("\(selectedWeekDay?.date.weekDayWideTitle)")
        }
    }
}

#Preview {
    StepPieChart(chartData: ChartMath.averageWeekDayCount(for: HealthMetric.mockData))
}
