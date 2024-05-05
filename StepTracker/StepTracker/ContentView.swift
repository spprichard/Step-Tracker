//
//  ContentView.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-05.
//

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

struct ContentView: View {
    @State
    private var selectedStat: HealthMetricContext = .steps
    
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
                                    
                                    Text("Avg: 10k Steps")
                                        .font(.caption)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
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
            .navigationTitle("Dasboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                Text(metric.title)
            }
        }
        .tint(selectedStat.tint)
    }
}

#Preview {
    ContentView()
}
