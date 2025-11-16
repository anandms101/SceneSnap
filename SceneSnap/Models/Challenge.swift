//
//  Challenge.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation

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

