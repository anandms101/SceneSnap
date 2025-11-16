//
//  LeaderboardViewModel.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation
import SwiftUI
import Combine

class LeaderboardViewModel: ObservableObject {
    @Published var entries: [LeaderboardEntry] = []
    @Published var currentChallenge: Challenge?
    @Published var isLoading: Bool = false
    
    // TODO: Implement leaderboard methods
    func fetchLeaderboard(challengeId: String) {
        isLoading = true
        // TODO: Call PostService to fetch top posts
        isLoading = false
    }
    
    func fetchCurrentChallenge() {
        // TODO: Call ChallengeService
    }
    
    @MainActor
    func refreshLeaderboard() async {
        fetchCurrentChallenge()
        if let challengeId = currentChallenge?.id {
            fetchLeaderboard(challengeId: challengeId)
        }
    }
}

