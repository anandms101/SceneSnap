//
//  LoginView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Login screen for user authentication.
//  Supports email/password login and Google sign-in with navigation to sign up.

import SwiftUI

/// Login screen for user authentication
/// Features:
/// - Email and password input fields
/// - Login button
/// - Google sign-in option
/// - Navigation to sign up screen
/// - Test credentials display for demo purposes
struct LoginView: View {
    /// ViewModel managing authentication logic
    @StateObject private var viewModel = AuthViewModel()
    
    /// User's email input
    @State private var email: String = ""
    
    /// User's password input
    @State private var password: String = ""
    
    /// Controls presentation of sign up sheet
    @State private var showSignUp: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("SceneSnap")
                .font(.largeTitle)
                .fontWeight(.bold)
                .underline()
                .padding(.top, 40)
            
            Text("Sign in to your account")
                .font(.headline)
                .foregroundColor(.secondary)
            
            // Test Credentials Info
            VStack(spacing: 8) {
                Text("For testing (no DB required):")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Email: test@gmail.com")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .fontWeight(.semibold)
                Text("Password: test@2025")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)
            
            // Input Fields
            VStack(spacing: 15) {
                VStack(spacing: 6) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    ValidationBadge(state: emailState)
                }
                
                VStack(spacing: 6) {
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    ValidationBadge(state: passwordState)
                }
            }
            .padding(.horizontal)
            
            // Login Button
            Button(action: {
                viewModel.signIn(email: email, password: password)
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.black)
                    }
                    Text("Log in")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(canSubmit ? Color.yellow : Color.gray.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(12)
            }
            .disabled(!canSubmit)
            .padding(.horizontal)
            
            // Divider
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                Text("or")
                    .foregroundColor(.gray)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // Google Login Button
            Button(action: {
                // TODO: Implement Google sign in
            }) {
                Text("Continue with google")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // Sign Up Link
            Button(action: { showSignUp = true }) {
                Text("Need an account? Sign up")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding(.bottom)
            
            Spacer()
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
    }
    
    private var emailState: ValidationState {
        viewModel.emailValidationState(for: email)
    }
    
    private var passwordState: ValidationState {
        viewModel.passwordValidationState(for: password)
    }
    
    private var canSubmit: Bool {
        emailState.isValid && passwordState.isValid && !viewModel.isLoading
    }
}

#Preview {
    LoginView()
}
