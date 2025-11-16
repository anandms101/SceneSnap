//
//  User.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation

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

