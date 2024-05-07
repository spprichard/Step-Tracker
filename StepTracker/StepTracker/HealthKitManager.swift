//
//  HealthKitManager.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-07.
//

import HealthKit
import Observation

@Observable
final class HealthKitManager {
    let store = HKHealthStore()
    
    static let readTypes: Set<HKQuantityType> = [
        HKQuantityType(.stepCount),
        HKQuantityType(.bodyMass)
    ]
    
    static let writeTypes: Set<HKQuantityType> = [
        HKQuantityType(.stepCount),
        HKQuantityType(.bodyMass)
    ]
}
