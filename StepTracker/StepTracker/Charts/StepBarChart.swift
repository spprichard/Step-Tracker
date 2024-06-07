//
//  StepBarChart.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-15.
//

import Charts
import SwiftUI

struct StepBarChart: View {
    @State
    private var rawSelectedDate: Date?
    
    var selectedStat: HealthMetricContext
    var chartData: [HealthMetric]
    
    var averageStepCount: Double {
        guard !chartData.isEmpty else {
            return 0
        }
        let stepSum = chartData.reduce(0) { $0 + $1.value }
        return stepSum / Double(chartData.count)
    }
    
    private var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return chartData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var body: some View {
        VStack {
            NavigationLink(value: selectedStat) {
                HStack {
                    VStack(alignment: .leading) {
                        Label("Steps", systemImage: "figure.walk")
                            .font(.title3.bold())
                            .foregroundStyle(.pink)
                        
                        Text("Avg: \(Int(averageStepCount)) Steps")
                            .font(.caption)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(.secondary)
            .padding(.bottom, 12)
            
            Chart {
                if let selectedHealthMetric {
                    RuleMark(x: .value("Selected Metric", selectedHealthMetric.date, unit: .day))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                        .offset(y: -10)
                        .annotation(
                            position: .top,
                            overflowResolution: .init(
                                x: .fit,
                                y: .disabled
                            ),
                            content: {
                                AnnotationView()
                            }
                        )
                }
                
                RuleMark(y: .value("Average", averageStepCount))
                    .foregroundStyle(Color.secondary)
                    .lineStyle(.init(lineWidth: 1, dash: [5]))
                
                ForEach(chartData) { steps in
                    BarMark(
                        x: .value("Date", steps.date, unit: .day),
                        y: .value("Steps", steps.value)
                    )
                    .foregroundStyle(Color.pink.gradient)
                    .opacity(rawSelectedDate == nil || steps.date == selectedHealthMetric?.date ? 1.0 : 0.3)
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


extension StepBarChart {
    @ViewBuilder
    func AnnotationView() -> some View {
        VStack {
            Text(selectedHealthMetric?.date ?? .now, format: 
                .dateTime
                .weekday(.abbreviated)
                .day(.defaultDigits)
                .month(.abbreviated)
            )
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
            Text(selectedHealthMetric?.value ?? 0, format: .number.precision(.fractionLength(0)))
                .fontWeight(.heavy)
                .foregroundStyle(.pink)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .secondary.opacity(0.45), radius: 2, x: 2, y: 2)
        )
    }
}

#Preview {
    StepBarChart(
        selectedStat: .steps,
        chartData: MockData.steps
    )
}
