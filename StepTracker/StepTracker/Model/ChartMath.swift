//
//  ChartMath.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-19.
//

import Foundation
import Algorithms

struct ChartMath {
    static func averageWeekDayCount(for metric: [HealthMetric]) -> [WeekDayChartData] {
        return metric
            .sorted { $0.date.weekDayInt < $1.date.weekDayInt }
            .chunked { $0.date.weekDayInt == $1.date.weekDayInt }
            .compactMap {
                guard let firstValue = $0.first else { return nil }
                let sum = $0.reduce(0) { $0 + $1.value }
                let mean = sum / Double($0.count)
                return WeekDayChartData(date: firstValue.date, value: mean)
            }
    }
}
