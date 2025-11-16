//
//  AdminChallengeViewModel.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation
import SwiftUI
import Combine

class AdminChallengeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // TODO: Implement admin challenge methods
    func createChallenge(challenge: Challenge) {
        isLoading = true
        // TODO: Call ChallengeService.createChallenge
        isLoading = false
    }
    
    func validateChallenge(title: String, tag: String, startDate: Date, endDate: Date) -> Bool {
        guard !title.isEmpty, !tag.isEmpty else { return false }
        guard endDate > startDate else { return false }
        return true
    }
}

