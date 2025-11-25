//
//  PostPreviewViewModel.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  ViewModel managing post preview and upload operations.
//  Handles post validation, challenge suggestions, and media upload to Firebase.

import Foundation
import SwiftUI
import Combine

/// ViewModel managing post preview screen state and operations
/// Handles post data input, validation, and upload to Firebase Storage/Firestore
/// Manages upload progress and post validation logic
class PostPreviewViewModel: ObservableObject {
    /// Post caption text entered by user
    @Published var caption: String = ""
    
    /// Challenge tag/name associated with the post
    @Published var challengeTag: String = ""
    
    /// Location where the post was created (optional)
    @Published var location: String = ""
    
    /// Whether post upload is currently in progress
    @Published var isUploading: Bool = false
    
    /// Upload progress from 0.0 to 1.0
    @Published var uploadProgress: Double = 0.0
    
    /// Optional URL for original scene media (if user uploaded comparison)
    @Published var originalSceneURL: String?
    
    /// Uploads the post to Firebase Storage and Firestore
    /// - Parameters:
    ///   - mediaURL: URL of the media file to upload
    ///   - mediaType: Type of media (video or photo)
    ///   - originalSceneURL: Optional URL of original scene for comparison
    /// - Note: Will call PostService to handle Firebase upload
    func uploadPost(mediaURL: URL, mediaType: Post.MediaType, originalSceneURL: URL? = nil) {
        isUploading = true
        uploadProgress = 0.0
        // TODO: Call PostService to upload media to Storage and create Firestore document
        isUploading = false
    }
    
    /// Fetches list of current challenges for tag suggestions
    /// - Returns: Array of challenge tag strings
    /// - Note: Will fetch from ChallengeService
    func getChallengeSuggestions() -> [String] {
        // TODO: Fetch current challenges for suggestions
        return []
    }
    
    /// Validates that post has required fields before uploading
    /// - Returns: True if post is valid (has caption and challenge tag), false otherwise
    func validatePost() -> Bool {
        // TODO: Add more validation (caption length, challenge tag format, etc.)
        return !caption.isEmpty && !challengeTag.isEmpty
    }
}

