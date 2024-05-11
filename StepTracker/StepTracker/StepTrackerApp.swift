//
//  StepTrackerApp.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-05.
//

import SwiftUI

@main
struct StepTrackerApp: App {
    let hkManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        .environment(hkManager)
    }
}
