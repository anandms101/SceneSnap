//
//  FeedView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Main feed view displaying posts and weekly challenge banner.
//  Supports navigation to leaderboard and user profiles.

import SwiftUI

/// Main feed screen displaying user posts and weekly challenges
/// Features:
/// - Weekly challenge banner (navigates to leaderboard)
/// - Scrollable list of posts with pull-to-refresh
/// - Navigation to user profiles when tapping usernames
/// - Empty state when no posts are available
struct FeedView: View {
    /// ViewModel managing feed data and business logic
    @StateObject private var viewModel = FeedViewModel()
    
    /// User ID selected for profile navigation
    @State private var selectedUserId: String?
    
    /// Controls navigation to leaderboard view
    @State private var showLeaderboard: Bool = false
    
    /// Controls navigation to profile view
    @State private var showProfile: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Weekly Challenge Banner - Tappable, navigates to leaderboard
                    if let challenge = viewModel.currentChallenge {
                        WeeklyChallengeBanner(challenge: challenge) {
                            showLeaderboard = true
                        }
                        .padding(.horizontal)
                    }
                    
                    // Posts list - Each post is tappable to view user profile
                    ForEach(viewModel.posts) { post in
                        PostCardView(post: post, onUserTap: {
                            selectedUserId = post.userId
                            showProfile = true
                        })
                    }
                    
                    // Empty state when no posts available
                    if viewModel.posts.isEmpty {
                        Text("No posts yet")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                // Pull-to-refresh functionality
                await viewModel.refreshFeed()
            }
            .navigationTitle("SceneSnap")
            .navigationBarTitleDisplayMode(.inline)
            // Navigation to leaderboard when challenge banner is tapped
            .navigationDestination(isPresented: $showLeaderboard) {
                LeaderboardView()
            }
            // Navigation to user profile when username is tapped
            .navigationDestination(isPresented: $showProfile) {
                if let userId = selectedUserId {
                    ProfileView(userId: userId)
                }
            }
        }
    }
}

#Preview {
    FeedView()
}

