//
//  ProfileViewModel.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var userPosts: [Post] = []
    @Published var isLoading: Bool = false
    
    // TODO: Implement profile methods
    func fetchUserProfile(userId: String) {
        isLoading = true
        // TODO: Call FirestoreService
        isLoading = false
    }
    
    func updateProfile(updates: [String: Any]) {
        // TODO: Update user profile in Firestore
    }
    
    func uploadProfileImage(image: UIImage) {
        // TODO: Upload image to Storage and update profile
    }
    
    func fetchUserPosts(userId: String) {
        // TODO: Fetch posts by user
    }
}

