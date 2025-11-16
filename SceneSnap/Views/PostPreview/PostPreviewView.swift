//
//  PostPreviewView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct PostPreviewView: View {
    @StateObject private var viewModel = PostPreviewViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showOriginalScenePicker: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Post preview")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                    
                    // User Info Section
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading) {
                            Text("Username")
                            TextField("Location", text: $viewModel.location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Media Preview
                    // TODO: Show recorded video/image
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay(
                            Text("Video Recorded")
                                .foregroundColor(.secondary)
                        )
                        .padding(.horizontal)
                    
                    // Original Scene Section
                    VStack(alignment: .leading) {
                        Text("Original Scene (Optional)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Button(action: {
                            showOriginalScenePicker = true
                        }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                Text("Add Original Scene")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        // Show original scene if added
                        if viewModel.originalSceneURL != nil {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay(
                                    Text("Original Scene Preview")
                                        .foregroundColor(.secondary)
                                )
                                .padding(.horizontal)
                        }
                    }
                    
                    // Caption Field
                    TextField("Caption", text: $viewModel.caption, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                        .padding(.horizontal)
                    
                    // Challenge Tag Field
                    TextField("Challenge tag/Name", text: $viewModel.challengeTag)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Post Button
                    Button(action: {
                        // TODO: Upload post
                        dismiss()
                    }) {
                        Text("Post")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .disabled(viewModel.isUploading)
                    
                    if viewModel.isUploading {
                        ProgressView(value: viewModel.uploadProgress)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showOriginalScenePicker) {
            // TODO: Show image/video picker for original scene
            Text("Original Scene Picker")
        }
    }
}

#Preview {
    PostPreviewView()
}

