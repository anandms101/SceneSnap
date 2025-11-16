//
//  LeaderboardEntry.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation

struct LeaderboardEntry: Identifiable {
    let id: String // Post ID
    let userId: String
    var username: String
    var profileImageURL: String?
    var postMediaURL: String
    var originalSceneURL: String?
    var likeCount: Int
    var postId: String
    
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

