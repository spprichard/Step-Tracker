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
                            RuleMark(y: .value("Average", averageStepCount))
                                .foregroundStyle(Color.secondary)
                                .lineStyle(.init(lineWidth: 1, dash: [5]))
                            
                            ForEach(hkManager.stepData) { steps in
                                BarMark(
                                    x: .value("Date", steps.date, unit: .day),
                                    y: .value("Steps", steps.value)
                                ).foregroundStyle(Color.pink.gradient)
                            }
                        }
                        .frame(height: 150)
                        . chartXAxis {
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
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    
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
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
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
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
