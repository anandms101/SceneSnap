//
//  AuthViewModel.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // TODO: Implement authentication methods
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        // Test credentials for demo purposes (remove when DB is connected)
        if email.lowercased() == "test@gmail.com" && password == "test@2025" {
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
    
    func signUp(userData: User) {
        isLoading = true
        errorMessage = nil
        // TODO: Call AuthService
    }
    
    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        // TODO: Implement Google Sign In
    }
    
    func signOut() {
        // TODO: Implement sign out
        isAuthenticated = false
        currentUser = nil
    }
    
    func checkAuthState() {
        // TODO: Check Firebase Auth state
    }
}

// MARK: - Validation Helpers

extension AuthViewModel {
    func emailValidationState(for email: String) -> ValidationState {
        guard !email.isEmpty else {
            return ValidationState(status: .idle, message: "Enter your email address.")
        }
        let predicate = NSPredicate(
            format: "SELF MATCHES %@",
            "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        )
        if predicate.evaluate(with: email) {
            return ValidationState(status: .valid, message: "Email looks good!")
        } else {
            return ValidationState(status: .invalid, message: "Please enter a valid email.")
        }
    }
    
    func passwordValidationState(for password: String) -> ValidationState {
        guard !password.isEmpty else {
            return ValidationState(status: .idle, message: "Password must be at least 8 characters.")
        }
        let hasMinCount = password.count >= 8
        let hasNumber = password.range(of: "\\d", options: .regularExpression) != nil
        if hasMinCount && hasNumber {
            return ValidationState(status: .valid, message: "Strong password ready.")
        } else {
            return ValidationState(status: .invalid, message: "Include 8+ chars and a number.")
        }
    }
}

struct ValidationState {
    enum Status {
        case idle, valid, invalid
    }
    
    let status: Status
    let message: String
    
    var isValid: Bool {
        status == .valid
    }
}
