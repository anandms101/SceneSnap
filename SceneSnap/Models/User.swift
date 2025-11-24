//
//  User.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  User model representing an app user with profile information,
//  statistics, and authentication data.

import Foundation

/// Represents a user in the SceneSnap application
/// Contains profile information, engagement statistics, and admin status
/// Conforms to Identifiable for SwiftUI and Codable for Firestore
struct User: Identifiable, Codable {
    let id: String // Firebase Auth UID
    var fullName: String
    var email: String
    var phoneNumber: String?
    var dateOfBirth: Date?
    var username: String
    var profileImageURL: String?
    var bio: String?
    var points: Int // Challenge participation points
    var totalLikes: Int
    var totalPosts: Int
    var createdAt: Date
    var updatedAt: Date
    var isAdmin: Bool // Admin role for challenge management
    
    /// Initializes a new User with required fields
    /// - Parameters:
    ///   - id: Firebase Authentication UID
    ///   - fullName: User's full name
    ///   - email: User's email address
    ///   - username: Unique username for the user
    init(id: String, fullName: String, email: String, username: String) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.username = username
        self.phoneNumber = nil
        self.dateOfBirth = nil
        self.profileImageURL = nil
        self.bio = nil
        self.points = 0
        self.totalLikes = 0
        self.totalPosts = 0
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isAdmin = false
    }
}

