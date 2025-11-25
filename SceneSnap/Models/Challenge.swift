//
//  Challenge.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Challenge model representing a weekly challenge that users can participate in.
//  Challenges have a time period, description, and track participant count.

import Foundation

/// Represents a weekly challenge that users can participate in
/// Challenges have a start and end date, and users can submit posts tagged with the challenge
/// Conforms to Identifiable and Codable for Firestore integration
struct Challenge: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var tag: String // Short tag for posts (e.g., "RomComWeek")
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    var participantCount: Int
    var createdAt: Date
    var createdBy: String? // Admin user ID who created the challenge
    
    /// Initializes a new Challenge
    /// - Parameters:
    ///   - id: Unique challenge identifier
    ///   - title: Display title of the challenge
    ///   - description: Detailed description of the challenge
    ///   - tag: Short tag used for filtering posts (e.g., "RomComWeek")
    ///   - startDate: When the challenge begins
    ///   - endDate: When the challenge ends
    init(id: String, title: String, description: String, tag: String, startDate: Date, endDate: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.tag = tag
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = true
        self.participantCount = 0
        self.createdAt = Date()
        self.createdBy = nil
    }
}

