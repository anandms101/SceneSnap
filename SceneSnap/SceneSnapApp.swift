//
//  SceneSnapApp.swift
//  SceneSnap
//
//  Created by Anand Mohan Singh on 11/15/25.
//
//  Main app entry point. Handles authentication state and root view navigation.

import SwiftUI

/// Main application entry point
/// Manages root-level navigation based on authentication state
@main
struct SceneSnapApp: App {
    /// Shared application state for authentication management
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            // Root navigation: Show MainTabView if authenticated, LoginView otherwise
            if appState.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}
