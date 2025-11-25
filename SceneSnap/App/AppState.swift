//
//  AppState.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Global application state management using Singleton pattern.
//  Manages authentication state and current user information across the app.

import Foundation
import Combine

/// Global application state manager
/// Uses Singleton pattern to provide shared state across the entire application
/// Manages authentication status and current user information
class AppState: ObservableObject {
    /// Indicates whether the user is currently authenticated
    @Published var isAuthenticated: Bool = false
    
    /// The currently logged-in user, nil if not authenticated
    @Published var currentUser: User?
    
    /// Shared singleton instance accessible throughout the app
    static let shared = AppState()
    
    /// Private initializer to enforce Singleton pattern
    private init() {}
}

