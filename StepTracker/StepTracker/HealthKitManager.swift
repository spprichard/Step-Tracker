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
    
    static let HasSeenPermissionSheetKey = "hasSeenPermissionSheet"
}

#if targetEnvironment(simulator)
extension HealthKitManager {
    func addSimulatorData() async {
        var mockSamples: [HKQuantitySample] = []
        
        for i in 0..<28 {
            let stepQuantity = HKQuantity(unit: .count(), doubleValue: .random(in: 4_000...20_000))
            let startDate = Calendar.current.date(byAdding: .day, value: -i, to: .now)!
            let stepSample = HKQuantitySample(
                type: .init(.stepCount),
                quantity: stepQuantity,
                start: startDate,
                end: startDate
            )
            mockSamples.append(stepSample)
            
            let weightQuantity = HKQuantity(unit: .pound(), doubleValue: .random(in: (160 + Double(i/3)...(165 + Double(i/3)))))
            let weightSample = HKQuantitySample(
                type: .init(.bodyMass),
                quantity: weightQuantity,
                start: startDate,
                end: startDate
            )
            mockSamples.append(weightSample)
        }
        
        do {
            try await store.save(mockSamples)
            print("ℹ️ Uploaded Health Store with mock data")
        } catch(let error) {
            fatalError("❌ Failed creating mock samples: \(error.localizedDescription)")
        }
        
    }
}
#endif
