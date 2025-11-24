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
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                DatePicker("Date of birth", selection: $dateOfBirth, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            // Register Button
            Button(action: {
                // Create user data
                var newUser = User(
                    id: UUID().uuidString,
                    fullName: fullName,
                    email: email,
                    username: fullName.lowercased().replacingOccurrences(of: " ", with: "")
                )
                newUser.dateOfBirth = dateOfBirth
                newUser.phoneNumber = phoneNumber.isEmpty ? nil : phoneNumber
                
                viewModel.signUp(userData: newUser)
                
                // If sign up successful, dismiss
                if viewModel.isAuthenticated {
                    dismiss()
                }
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .disabled(fullName.isEmpty || email.isEmpty || password.isEmpty)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.horizontal)
            }
            
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
}

#Preview {
    SignUpView()
}

