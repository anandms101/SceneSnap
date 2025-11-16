//
//  LoginView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
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
            
            Text("Enter your email and pass. to log in")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Test Credentials Info
            VStack(spacing: 8) {
                Text("For testing (no DB required):")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Email: test")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .fontWeight(.semibold)
                Text("Password: test")
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
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            // Login Button
            Button(action: {
                viewModel.signIn(email: email, password: password)
            }) {
                Text("Log in")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
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
            
            Spacer()
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
    }
}

#Preview {
    LoginView()
}

