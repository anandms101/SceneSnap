//
//  Constants.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation

struct Constants {
    // Media Limits
    static let MAX_VIDEO_DURATION: TimeInterval = 60.0 // seconds
    static let MAX_VIDEO_SIZE: Int64 = 100 * 1024 * 1024 // 100 MB
    static let MAX_IMAGE_SIZE: Int64 = 10 * 1024 * 1024 // 10 MB
    
    // Text Limits
    static let MAX_CAPTION_LENGTH: Int = 500
    static let MAX_BIO_LENGTH: Int = 200
    static let MAX_USERNAME_LENGTH: Int = 30
    
    // Pagination
    static let POSTS_PER_PAGE: Int = 20
    static let COMMENTS_PER_PAGE: Int = 50
    
    // Firebase Collections
    struct Firestore {
        static let users = "users"
        static let posts = "posts"
        static let challenges = "challenges"
        static let comments = "comments"
    }
    
    // Storage Paths
    struct Storage {
        static let users = "users"
        static let posts = "posts"
        static let profile = "profile"
        static let originalScenes = "originalScenes"
    }
    
    // Points System
    struct Points {
        static let participationPoints: Int = 10
        static let firstPlaceBonus: Int = 50
        static let secondPlaceBonus: Int = 30
        static let thirdPlaceBonus: Int = 20
    }
}

