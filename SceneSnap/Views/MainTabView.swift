//
//  MainTabView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Main tab navigation view providing access to Feed, Capture, and Profile screens.
//  This is the root view shown after successful authentication.

import SwiftUI

/// Main tab navigation container for authenticated users
/// Provides bottom tab bar navigation between three main sections:
/// - Feed: View posts and challenges
/// - Capture: Record or upload media for new posts
/// - Profile: View and edit user profile
struct MainTabView: View {
    /// Currently selected tab index (0: Feed, 1: Capture, 2: Profile)
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Feed Tab - Home screen with posts and challenges
            FeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            // Capture Tab - Media recording and upload
            CaptureView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Capture")
                }
                .tag(1)
            
            // Profile Tab - User profile and settings
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(.yellow) // App theme color
    }
}

#Preview {
    MainTabView()
}

