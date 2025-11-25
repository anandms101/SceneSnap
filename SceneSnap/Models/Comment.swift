//
//  Comment.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Comment model representing a user's comment on a post.
//  Comments are associated with posts and contain user information and text content.

import Foundation

/// Represents a comment on a post
/// Contains the comment text, author information, and timestamp
/// Conforms to Identifiable for SwiftUI list rendering and Codable for Firestore
struct Comment: Identifiable, Codable {
    let id: String
    let postId: String
    let userId: String
    var username: String
    var profileImageURL: String?
    var text: String
    var createdAt: Date
    
    /// Initializes a new Comment
    /// - Parameters:
    ///   - id: Unique comment identifier
    ///   - postId: ID of the post this comment belongs to
    ///   - userId: ID of the user who wrote the comment
    ///   - username: Display name of the comment author
    ///   - text: The comment text content
    init(id: String, postId: String, userId: String, username: String, text: String) {
        self.id = id
        self.postId = postId
        self.userId = userId
        self.username = username
        self.text = text
        self.profileImageURL = nil
        self.createdAt = Date()
    }
}

