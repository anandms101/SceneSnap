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
        NavigationView {
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
                        // TODO: Save profile updates
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileView()
}

