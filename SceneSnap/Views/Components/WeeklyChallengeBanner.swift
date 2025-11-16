//
//  WeeklyChallengeBanner.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct WeeklyChallengeBanner: View {
    let challenge: Challenge
    
    var body: some View {
        Button(action: {
            // TODO: Navigate to LeaderboardView
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Weekly challenge")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(challenge.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.yellow.opacity(0.2))
            .cornerRadius(12)
        }
    }
}

#Preview {
    WeeklyChallengeBanner(challenge: Challenge(
        id: "1",
        title: "Rom-Com Week",
        description: "Recreate your favorite rom-com scene",
        tag: "RomComWeek",
        startDate: Date(),
        endDate: Date().addingTimeInterval(7 * 24 * 60 * 60)
    ))
}

