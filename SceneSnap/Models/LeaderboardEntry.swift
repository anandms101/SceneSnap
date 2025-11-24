//
//  LeaderboardEntry.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  LeaderboardEntry model representing a post's ranking in the leaderboard.
//  Used to display top posts for a challenge based on like count.

import Foundation

/// Represents an entry in the leaderboard for a challenge
/// Contains post information and like count for ranking purposes
/// Conforms to Identifiable for SwiftUI list rendering
struct LeaderboardEntry: Identifiable {
    let id: String // Post ID
    let userId: String
    var username: String
    var profileImageURL: String?
    var postMediaURL: String
    var originalSceneURL: String?
    var likeCount: Int
    var postId: String
    
    /// Initializes a new LeaderboardEntry
    /// - Parameters:
    ///   - id: Unique entry identifier (typically the post ID)
    ///   - userId: ID of the user who created the post
    ///   - username: Display name of the user
    ///   - postMediaURL: Firebase Storage URL for the post media
    ///   - likeCount: Number of likes the post has received
    ///   - postId: ID of the associated post
    init(id: String, userId: String, username: String, postMediaURL: String, likeCount: Int, postId: String) {
        self.id = id
        self.userId = userId
        self.username = username
        self.postMediaURL = postMediaURL
        self.originalSceneURL = nil
        self.likeCount = likeCount
        self.postId = postId
        self.profileImageURL = nil
    }
}

