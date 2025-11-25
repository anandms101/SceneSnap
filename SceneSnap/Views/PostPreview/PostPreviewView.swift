//
//  PostPreviewView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Post preview screen for reviewing and editing post details before publishing.
//  Allows users to add caption, challenge tag, location, and optional original scene.

import SwiftUI

/// Post preview and editing screen before publishing
/// Features:
/// - Media preview (video or image)
/// - Caption input
/// - Challenge tag selection
/// - Location input
/// - Optional original scene upload
/// - Post upload with progress tracking
struct PostPreviewView: View {
    /// URL of recorded video (if video was captured)
    let mediaURL: URL?
    
    /// Selected image from gallery (if image was selected)
    let selectedImage: UIImage?
    
    /// ViewModel managing post preview state and upload logic
    @StateObject private var viewModel = PostPreviewViewModel()
    
    /// Environment value for dismissing the view
    @Environment(\.dismiss) var dismiss
    
    /// Controls presentation of original scene picker
    @State private var showOriginalScenePicker: Bool = false
    
    /// Initializes PostPreviewView with captured media
    /// - Parameters:
    ///   - mediaURL: URL of recorded video (optional)
    ///   - selectedImage: Selected image from gallery (optional)
    init(mediaURL: URL? = nil, selectedImage: UIImage? = nil) {
        self.mediaURL = mediaURL
        self.selectedImage = selectedImage
    }
    
    var body: some View {
        NavigationStack {
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
                            Text(AppState.shared.currentUser?.username ?? "Username")
                                .fontWeight(.semibold)
                            TextField("Location", text: $viewModel.location)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Media Preview
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 300)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    } else if let url = mediaURL {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                            .overlay(
                                VStack {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                    Text("Video Preview")
                                        .foregroundColor(.white)
                                }
                            )
                            .cornerRadius(8)
                            .padding(.horizontal)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                            .overlay(
                                Text("No media selected")
                                    .foregroundColor(.secondary)
                            )
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    
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
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Caption")
                            .font(.headline)
                            .padding(.horizontal)
                        TextField("Write a caption...", text: $viewModel.caption, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                            .padding(.horizontal)
                    }
                    
                    // Challenge Tag Field
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Challenge tag/Name")
                            .font(.headline)
                            .padding(.horizontal)
                        TextField("Enter challenge tag", text: $viewModel.challengeTag)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                    
                    // Post Button
                    Button(action: {
                        if let url = mediaURL {
                            viewModel.uploadPost(mediaURL: url, mediaType: .video, originalSceneURL: nil)
                        } else if selectedImage != nil {
                            // For images, we'd need to convert UIImage to URL
                            // For now, just dismiss
                            viewModel.isUploading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                viewModel.isUploading = false
                                dismiss()
                            }
                        }
                    }) {
                        Text("Post")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.validatePost() && !viewModel.isUploading ? Color.yellow : Color.gray)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .disabled(viewModel.isUploading || !viewModel.validatePost())
                    
                    if viewModel.isUploading {
                        ProgressView(value: viewModel.uploadProgress)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Post Preview")
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
        .onAppear {
            // Set default challenge tag if available
            if viewModel.challengeTag.isEmpty {
                // Could fetch current challenge here
            }
        }
    }
}

#Preview {
    PostPreviewView()
}

