//
//  ProfileView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showEditProfile: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Profile Page")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                    
                    // Profile Header
                    VStack(spacing: 10) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                        
                        if let user = viewModel.user {
                            Text(user.username)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding()
                    
                    // User Details Section
                    VStack(alignment: .leading, spacing: 10) {
                        if let user = viewModel.user {
                            Text("Email: \(user.email)")
                            if let phone = user.phoneNumber {
                                Text("Phone: \(phone)")
                            }
                            if let dob = user.dateOfBirth {
                                Text("Date of Birth: \(dob, style: .date)")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Stats Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Stats")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if let user = viewModel.user {
                            Text("Points: \(user.points)")
                            Text("Likes: \(user.totalLikes)")
                            Text("Posts: \(user.totalPosts)")
                        }
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Update Bio Button
                    Button(action: {
                        showEditProfile = true
                    }) {
                        Text("Update Bio")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Logout Button
                    Button(action: {
                        // TODO: Implement logout
                    }) {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
        }
        .onAppear {
            // TODO: Fetch user profile
        }
    }
}

#Preview {
    ProfileView()
}

