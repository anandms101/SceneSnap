//
//  AuthViewModel.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  ViewModel for authentication operations.
//  Handles user sign in, sign up, sign out, and authentication state management.

import Foundation
import SwiftUI
import Combine

/// ViewModel managing authentication state and operations
/// Handles user login, registration, and session management
/// Updates AppState.shared for global authentication state
class AuthViewModel: ObservableObject {
    /// Whether the user is currently authenticated
    @Published var isAuthenticated: Bool = false
    
    /// Currently authenticated user, nil if not logged in
    @Published var currentUser: User?
    
    /// Loading state for async authentication operations
    @Published var isLoading: Bool = false
    
    /// Error message to display to user if authentication fails
    @Published var errorMessage: String?
    
    /// Signs in a user with email and password
    /// Currently supports test credentials for demo purposes
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Note: Test credentials: email="test", password="test"
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        // Test credentials for demo purposes (remove when DB is connected)
        if email.lowercased() == "test" && password == "test" {
            // Create a test user
            let testUser = User(
                id: "test-user-id",
                fullName: "Test User",
                email: "test@test.com",
                username: "testuser"
            )
            
            // Set authentication state
            AppState.shared.currentUser = testUser
            AppState.shared.isAuthenticated = true
            self.currentUser = testUser
            self.isAuthenticated = true
            isLoading = false
            return
        }
        
        // TODO: Call AuthService for real authentication
        isLoading = false
    }
    
    /// Registers a new user account
    /// Creates user in AppState and sets authentication state
    /// - Parameter userData: User object containing registration information
    /// - Note: Currently creates user directly for demo. Will integrate with AuthService for production.
    func signUp(userData: User) {
        isLoading = true
        errorMessage = nil
        
        // For demo purposes, create user directly
        AppState.shared.currentUser = userData
        AppState.shared.isAuthenticated = true
        self.currentUser = userData
        self.isAuthenticated = true
        isLoading = false
        
        // TODO: Call AuthService for real authentication
    }
    
    /// Signs in user using Google authentication
    /// - Note: Not yet implemented. Will integrate Google Sign-In SDK.
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        // TODO: Implement Google Sign In
    }
    
    /// Signs out the current user
    /// Clears authentication state from both ViewModel and AppState
    /// - Note: Will call AuthService.signOut() for production Firebase integration
    func signOut() {
        // Clear authentication state
        AppState.shared.isAuthenticated = false
        AppState.shared.currentUser = nil
        isAuthenticated = false
        currentUser = nil
        // TODO: Call AuthService.signOut() for real authentication
    }
    
    /// Checks the current authentication state
    /// Should be called on app launch to restore user session
    /// - Note: Will check Firebase Auth state for production
    func checkAuthState() {
        // TODO: Check Firebase Auth state
    }
}

