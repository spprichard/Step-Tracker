//
//  HealthKitPermissionView.swift
//  StepTracker
//
//  Created by Steven Prichard on 2024-05-07.
//

import SwiftUI

struct HealthKitPermissionView: View {
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
                print("TODO - Connect Apple Health")
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }.padding(20)
    }
    
    static let healthKitUsageDescription: String = """
    This app displays your step, weight & workout data in interactive charts.
    
    You can also add new steps or weight data to Apple Health from this app. Your data is private & secure.
    """
}

#Preview {
    HealthKitPermissionView()
}
