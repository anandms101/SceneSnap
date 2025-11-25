//
//  Post.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Post model representing a user's scene recreation submission.
//  Contains media (video/photo), caption, challenge association, and engagement metrics.

import Foundation

/// Represents a user's post/recreation of a movie or TV scene
/// Conforms to Identifiable for SwiftUI list rendering and Codable for Firestore serialization
struct Post: Identifiable, Codable {
    let id: String
    let userId: String
    var username: String
    var profileImageURL: String?
    var mediaURL: String // Firebase Storage URL - user's recreation
    var originalSceneURL: String? // Firebase Storage URL - original movie/TV scene
    var mediaType: MediaType // .video or .photo
    var originalMediaType: MediaType? // Type of original scene media
    var caption: String
    var challengeTag: String // Current weekly challenge name
    var challengeId: String? // Reference to Challenge document
    var location: String?
    var likes: [String] // Array of user IDs who liked
    var likeCount: Int
    var comments: [Comment]
    var commentCount: Int
    var createdAt: Date
    var updatedAt: Date
    
    /// Media type enumeration for posts
    /// Supports both video and photo recreations
    enum MediaType: String, Codable {
        case video, photo
    }
    
    /// Initializes a new Post with required fields
    /// - Parameters:
    ///   - id: Unique post identifier
    ///   - userId: ID of the user who created the post
    ///   - username: Display name of the user
    ///   - mediaURL: Firebase Storage URL for the recreation media
    ///   - mediaType: Type of media (video or photo)
    init(id: String, userId: String, username: String, mediaURL: String, mediaType: MediaType) {
        self.id = id
        self.userId = userId
        self.username = username
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.originalSceneURL = nil
        self.originalMediaType = nil
        self.profileImageURL = nil
        self.caption = ""
        self.challengeTag = ""
        self.challengeId = nil
        self.location = nil
        self.likes = []
        self.likeCount = 0
        self.comments = []
        self.commentCount = 0
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

