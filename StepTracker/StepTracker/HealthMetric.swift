//
//  HealthMetric.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-11.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

#if targetEnvironment(simulator)
extension HealthMetric {
    static var mockData: [HealthMetric] {
        var data: [HealthMetric] = []
        let calendar = Calendar.current
        
        for i in 0..<28 {
            let metric = HealthMetric(
                date: calendar.date(
                    byAdding: .day,
                    value: -i,
                    to: .now
                )!,
                value: .random(in: 4_000...15_000)
            )
            data.append(metric)
        }
        
        return data
    }
}
#endif
