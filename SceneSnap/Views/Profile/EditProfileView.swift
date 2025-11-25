//
//  EditProfileView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct EditProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var bio: String = ""
    @State private var username: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile Information") {
                    TextField("Username", text: $username)
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Profile Picture") {
                    Button(action: {
                        // TODO: Open image picker
                    }) {
                        HStack {
                            Text("Change Profile Picture")
                            Spacer()
                            Image(systemName: "photo")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                if let user = viewModel.user {
                    Section("Current Info") {
                        Text("Email: \(user.email)")
                        if let bio = user.bio {
                            Text("Bio: \(bio)")
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Update profile
                        var updates: [String: Any] = [:]
                        if !username.isEmpty {
                            updates["username"] = username
                        }
                        if !bio.isEmpty {
                            updates["bio"] = bio
                        }
                        viewModel.updateProfile(updates: updates)
                        dismiss()
                    }
                    .disabled(username.isEmpty && bio.isEmpty)
                }
            }
        }
        .onAppear {
            if let user = AppState.shared.currentUser {
                username = user.username
                bio = user.bio ?? ""
                viewModel.user = user
            }
        }
    }
}

#Preview {
    EditProfileView()
}

