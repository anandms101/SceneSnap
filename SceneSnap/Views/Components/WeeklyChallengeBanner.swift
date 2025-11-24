//
//  WeeklyChallengeBanner.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Reusable banner component displaying the current weekly challenge.
//  Tappable to navigate to leaderboard view.

import SwiftUI

/// Banner component displaying current weekly challenge information
/// Shows challenge title and provides tap action for navigation
/// Used in FeedView to highlight the active challenge
struct WeeklyChallengeBanner: View {
    /// The challenge to display
    let challenge: Challenge
    
    /// Optional callback when banner is tapped (typically navigates to leaderboard)
    var onTap: (() -> Void)?
    
    var body: some View {
        Button(action: {
            onTap?()
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

