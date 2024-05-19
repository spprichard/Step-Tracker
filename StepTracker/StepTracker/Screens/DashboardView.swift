//
//  DashboardView.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-05.
//

import Charts
import SwiftUI

enum HealthMetricContext: CaseIterable, Identifiable {
    case steps, weight, workouts
    
    var id: Self { self }
    var title: String {
        switch self {
        case .steps:
            "Steps"
        case .weight:
            "Weight"
        case .workouts:
            "Workouts"
        }
    }
    var tint: Color {
        switch self {
        case .steps:
            .pink
        case .weight:
            .indigo
        case .workouts:
            .green
        }
    }
}

struct DashboardView: View {
    @AppStorage(HealthKitManager.HasSeenPermissionSheetKey)
    private var hasSeenPermissionSheet = false
    
    @Environment(HealthKitManager.self)
    private var hkManager
    
    @State
    private var isShowingPermissionSheet = false
    
    @State
    private var selectedStat: HealthMetricContext = .steps
    
    @State
    private var rawSelectedDate: Date?
    
    private var selectedHealthMetric: HealthMetric? {
        guard let rawSelectedDate else { return nil }
        return hkManager.stepData.first {
            Calendar.current.isDate(rawSelectedDate, inSameDayAs: $0.date)
        }
    }
    
    var averageStepCount: Double {
        guard !hkManager.stepData.isEmpty else {
            return 0
        }
        let stepSum = hkManager.stepData.reduce(0) { $0 + $1.value }
        return stepSum / Double(hkManager.stepData.count)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Selected State", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) { metric in
                            Text(metric.title)
                        }
                    }.pickerStyle(.segmented)
                    
                    StepBarChart(
                        selectedStat: .steps,
                        chartData: hkManager.stepData
                    )
                    
                    StepPieChart(
                        chartData:
                            ChartMath.averageWeekDayCount(
                                for: HealthMetric.mockData
                            )
                    )
                }
            }
            .padding()
            .task {
                await hkManager.fetchStepCount()
                isShowingPermissionSheet = !hasSeenPermissionSheet
            }
            .navigationTitle("Dasboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: selectedStat)
            }
            .sheet(isPresented: $isShowingPermissionSheet,
                   onDismiss: {
                // TODO: Fetch Health Data
            },
                   content: {
                HealthKitPermissionView(hasSeen: $hasSeenPermissionSheet)
            }
            )
        }
        .tint(selectedStat.tint)
    }
    
    @ViewBuilder
    func AnnotationView() -> some View {
        VStack {
            Text(selectedHealthMetric?.date ?? .now, format: .dateTime.weekday(.abbreviated).month(.abbreviated))
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
    DashboardView()
        .environment(HealthKitManager())
}
