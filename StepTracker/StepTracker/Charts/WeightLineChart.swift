//
//  WeightLineChart.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-06-07.
//

import Charts
import SwiftUI

struct WeightLineChart: View {
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    @State
    private var rawSelectedDate: Date?
    
    private var minValue: Double {
        chartData.map { $0.value }.min() ?? 0
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Weight", systemImage: "figure")
                            .font(.title3.bold())
                            .foregroundStyle(.indigo)
                        
                        Text("Avg: 100 lbs")
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                RuleMark(y: .value("Goal", 155))
                    .lineStyle(.init(lineWidth: 1, dash: [5]))
                
                ForEach(chartData) { weight in
                    AreaMark(
                        x: .value("Day", weight.date, unit: .day),
                        yStart: .value("Weight", weight.value),
                        yEnd: .value("Min Value", minValue)
                    ).foregroundStyle(Gradient(colors: [.indigo, .clear]))
                    
                    LineMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value("Weight", weight.value)
                    )
                    .foregroundStyle(.indigo)
                    .interpolationMethod(.catmullRom)
                    .symbol(.circle)
                    
                }
            }
            .frame(height: 150)
            .chartYScale(domain: .automatic(includesZero: false))
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                        .foregroundStyle(.secondary.opacity(0.3))
                    
                    AxisValueLabel(
                        (value.as(Double.self) ?? 0)
                            .formatted(.number.notation(.compactName))
                    )
                    
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground)
            )
        )
    }
}

#Preview {
    WeightLineChart(
        selectedStat: .weight,
        chartData: MockData.weights
    )
}
