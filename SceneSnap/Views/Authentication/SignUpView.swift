//
//  SignUpView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("SceneSnap")
                .font(.largeTitle)
                .fontWeight(.bold)
                .underline()
                .padding(.top, 40)
            
            Text("Sign Up")
                .font(.title2)
                .fontWeight(.semibold)
            
            // Input Fields
            VStack(spacing: 15) {
                TextField("Full Name", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                VStack(spacing: 6) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    ValidationBadge(state: emailState)
                }
                
                DatePicker("Date of birth", selection: $dateOfBirth, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
                
                VStack(spacing: 6) {
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    ValidationBadge(state: passwordState)
                }
            }
            .padding(.horizontal)
            
            // Register Button
            Button(action: {
                // TODO: Implement sign up
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.black)
                    }
                    Text("Register")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(canRegister ? Color.yellow : Color.gray.opacity(0.3))
                .foregroundColor(.black)
                .cornerRadius(12)
            }
            .disabled(!canRegister)
            .padding(.horizontal)
            
            // Login Link
            Button(action: {
                dismiss()
            }) {
                Text("Already have an account? log in")
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
    }
    
    private var emailState: ValidationState {
        viewModel.emailValidationState(for: email)
    }
    
    private var passwordState: ValidationState {
        viewModel.passwordValidationState(for: password)
    }
    
    private var canRegister: Bool {
        !fullName.isEmpty && emailState.isValid && passwordState.isValid && !viewModel.isLoading
    }
}

#Preview {
    SignUpView()
}
