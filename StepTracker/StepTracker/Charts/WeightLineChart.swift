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
                ForEach(chartData) { weight in
                    AreaMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value("Weight", weight.value)
                    ).foregroundStyle(Gradient(colors: [.indigo, .clear]))
                    
                    LineMark(
                        x: .value("Day", weight.date, unit: .day),
                        y: .value("Weight", weight.value)
                    ).foregroundStyle(.indigo)
                }
            }
            .frame(height: 150)
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
