//
//  FeedViewModel.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation
import SwiftUI
import Combine

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var currentChallenge: Challenge?
    
    // TODO: Implement feed methods
    func fetchPosts(limit: Int = 20, lastDocument: String? = nil) {
        isLoading = true
        // TODO: Call PostService
        isLoading = false
    }
    
    func fetchCurrentChallenge() {
        // TODO: Call ChallengeService
    }
    
    func likePost(postId: String) {
        // TODO: Implement like functionality
    }
    
    func unlikePost(postId: String) {
        // TODO: Implement unlike functionality
    }
    
    @MainActor
    func refreshFeed() async {
        fetchCurrentChallenge()
        fetchPosts()
    }
}

