//
//  WeekDayChartData.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-19.
//

import Foundation


struct WeekDayChartData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
