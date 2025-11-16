//
//  Comment.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation

struct Comment: Identifiable, Codable {
    let id: String
    let postId: String
    let userId: String
    var username: String
    var profileImageURL: String?
    var text: String
    var createdAt: Date
    
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

