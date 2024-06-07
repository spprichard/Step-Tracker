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
    private let calendar = Calendar.current
    let store = HKHealthStore()
    
    var stepData: [HealthMetric] = []
    var weightData: [HealthMetric] = []
    
    static let readTypes: Set<HKQuantityType> = [
        HKQuantityType(.stepCount),
        HKQuantityType(.bodyMass)
    ]
    
    static let writeTypes: Set<HKQuantityType> = [
        HKQuantityType(.stepCount),
        HKQuantityType(.bodyMass)
    ]
    
    static let HasSeenPermissionSheetKey = "hasSeenPermissionSheet"
    
    func fetchStepCount() async {
        let today = calendar.startOfDay(for: .now)
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            fatalError("Failed creating endDate")
        }
        guard let startDate = calendar.date(byAdding: .day, value: -28, to: endDate) else {
            fatalError("Failed creating startDate")
        }
        
        let queryPredicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate
        )
    
        let samplePredicate = HKSamplePredicate.quantitySample(
            type: HKQuantityType(.stepCount),
            predicate: queryPredicate
        )
        
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .cumulativeSum,
            anchorDate: endDate,
            intervalComponents: DateComponents(day: 1)
        )
        
        do {
            let stepCounts = try await sumOfStepsQuery.result(for: store)
            stepData = stepCounts.statistics().map { stat in
                HealthMetric(
                    date: stat.startDate,
                    value: stat.sumQuantity()?.doubleValue(for: .count()) ?? 0
                )
            }
        } catch let error {
            // TODO: Properly Handle
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchWeight() async {
        let today = calendar.startOfDay(for: .now)
        guard let endDate = calendar.date(byAdding: .day, value: 1, to: today) else {
            fatalError("Failed creating endDate")
        }
        guard let startDate = calendar.date(byAdding: .day, value: -28, to: endDate) else {
            fatalError("Failed creating startDate")
        }
        
        let queryPredicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate
        )
    
        let samplePredicate = HKSamplePredicate.quantitySample(
            type: HKQuantityType(.bodyMass),
            predicate: queryPredicate
        )
        
        let statsQuery = HKStatisticsCollectionQueryDescriptor(
            predicate: samplePredicate,
            options: .mostRecent,
            anchorDate: endDate,
            intervalComponents: DateComponents(day: 1)
        )
        
        do {
            let results = try await statsQuery.result(for: store)
            weightData = results.statistics().map { stat in
                HealthMetric(
                    date: stat.startDate,
                    value: stat.mostRecentQuantity()?.doubleValue(for: .pound()) ?? 0
                )
            }
        } catch let error {
            // Properly Handle
            fatalError(error.localizedDescription)
        }
    }
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
