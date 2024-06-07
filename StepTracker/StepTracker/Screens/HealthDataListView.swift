//
//  HealthDataListView.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-05.
//

import SwiftUI

struct HealthDataListView: View {
    let metric: HealthMetricContext
    
    @State
    private var isShowingSheet = false
    
    @State
    private var dateToAdd = Date()
    
    @State
    private var valueToAdd = ""
    
    var body: some View {
        List(0..<28) { i in
            HStack {
                Text(Date(), format: .dateTime.month().day().year())
                Spacer()
                Text(1000,format:
                        .number
                        .precision(
                        .fractionLength(metricPercision())
                    )
                )
            }
        }
        .navigationTitle(metric.title)
        .sheet(isPresented: $isShowingSheet) {
            AddDataView()
                .presentationDetents([.fraction(0.25)])
        }
        .toolbar {
            Button("Add", systemImage: "plus") {
                isShowingSheet.toggle()
            }
        }
        
    }
    
    private func AddDataView() -> some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $dateToAdd)
                HStack {
                    Text(metric.title)
                    Spacer()
                    TextField("Value", text: $valueToAdd)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 140)
                        .keyboardType(metricKeyboardType())
                }
            }
            .navigationTitle(metric.title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss") {
                        isShowingSheet = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Data") {
                        // TODO: Implement
                    }
                }
            }
        }
    }
    
    private func metricKeyboardType() -> UIKeyboardType {
        switch metric {
        case .steps, .workouts:
            .numberPad
        case .weight:
            .decimalPad
        }
    }
    
    private func metricPercision() -> Int {
        switch metric {
        case .steps, .workouts:
            0
        case .weight:
            1
        }
    }
}

#Preview("Steps") {
    NavigationStack {
        HealthDataListView(metric: .steps)
    }
}

#Preview("Weight") {
    NavigationStack {
        HealthDataListView(metric: .weight)
    }
}
