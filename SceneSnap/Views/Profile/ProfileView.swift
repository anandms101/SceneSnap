//
//  ProfileView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  User profile screen displaying user information, stats, and posts.
//  Supports viewing both current user and other users' profiles.

import SwiftUI

/// User profile screen
/// Features:
/// - Profile picture and username display
/// - User details (email, phone, date of birth)
/// - Statistics (points, likes, posts)
/// - Edit profile functionality (for current user only)
/// - Logout functionality (for current user only)
/// - Can view other users' profiles when userId is provided
struct ProfileView: View {
    /// Optional user ID - if nil, shows current user's profile
    let userId: String?
    
    /// ViewModel managing profile data and operations
    @StateObject private var viewModel = ProfileViewModel()
    
    /// Controls presentation of edit profile sheet
    @State private var showEditProfile: Bool = false
    
    /// Environment value for dismissing the view (when viewing other users)
    @Environment(\.dismiss) var dismiss
    
    /// Initializes ProfileView
    /// - Parameter userId: Optional user ID. If nil, displays current user's profile.
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Profile Page")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                    
                    // Profile Header
                    VStack(spacing: 10) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                        
                        if let user = viewModel.user {
                            Text(user.username)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding()
                    
                    // User Details Section
                    VStack(alignment: .leading, spacing: 10) {
                        if let user = viewModel.user {
                            Text("Email: \(user.email)")
                            if let phone = user.phoneNumber {
                                Text("Phone: \(phone)")
                            }
                            if let dob = user.dateOfBirth {
                                Text("Date of Birth: \(dob, style: .date)")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Stats Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Stats")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if let user = viewModel.user {
                            Text("Points: \(user.points)")
                            Text("Likes: \(user.totalLikes)")
                            Text("Posts: \(user.totalPosts)")
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Update Bio Button
                    Button(action: {
                        showEditProfile = true
                    }) {
                        Text("Update Bio")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Logout Button (only show for current user)
                    if userId == nil {
                        Button(action: {
                            let authViewModel = AuthViewModel()
                            authViewModel.signOut()
                            AppState.shared.isAuthenticated = false
                            AppState.shared.currentUser = nil
                        }) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if userId != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            dismiss()
                        }
                    }
                }
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
        }
        .onAppear {
            if let userId = userId {
                viewModel.fetchUserProfile(userId: userId)
            } else {
                // Fetch current user profile
                if let currentUserId = AppState.shared.currentUser?.id {
                    viewModel.fetchUserProfile(userId: currentUserId)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}

