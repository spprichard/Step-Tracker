//
//  HealthKitPermissionView.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-07.
//

import SwiftUI
import HealthKitUI

struct HealthKitPermissionView: View {
    @Environment(HealthKitManager.self)
    var hkManager
    
    @State
    private var shouldConnectAppleHealth = false
    
    @Environment(\.dismiss)
    private var dismiss
    
    var body: some View {
        VStack(spacing: 125) {
            VStack(spacing: 16) {
                Image(.appleHealthIcon)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 16)
                Text("Apple Health Integration")
                    .font(.title2.bold())
                    .padding(.bottom, 20)
                
                Text(Self.healthKitUsageDescription)
                    .foregroundStyle(.secondary)
            }.multilineTextAlignment(.center)
            
            Button("Connect Apple Health") {
                shouldConnectAppleHealth = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(20)
        .healthDataAccessRequest(
            store: hkManager.store,
            shareTypes: HealthKitManager.writeTypes,
            readTypes: HealthKitManager.readTypes,
            trigger: shouldConnectAppleHealth,
            completion: onConnectHealthKit
        )
    }
    
    private func onConnectHealthKit(result: Result<Bool, Error>) {
        switch result {
        case .success:
            dismiss()
        case .failure(let failure):
            // TODO: Handle Error
            print("❌ Unhandled Error: \(failure.localizedDescription)")
            dismiss()
        }
    }
    
    static let healthKitUsageDescription: String = """
    This app displays your step, weight & workout data in interactive charts.
    
    You can also add new steps or weight data to Apple Health from this app. Your data is private & secure.
    """
}

#Preview {
    HealthKitPermissionView()
        .environment(HealthKitManager())
}
