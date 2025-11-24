//
//  CaptureView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Media capture screen for recording videos or selecting from gallery.
//  Provides camera controls and navigation to post preview.

import SwiftUI

/// Media capture screen for creating new posts
/// Features:
/// - Video recording with timer display
/// - Photo/video selection from gallery
/// - Camera switching (front/back)
/// - Navigation to post preview after media selection
struct CaptureView: View {
    /// ViewModel managing capture state and media handling
    @StateObject private var viewModel = CaptureViewModel()
    
    /// Controls presentation of post preview screen
    @State private var showPostPreview: Bool = false
    
    /// Environment value for dismissing the view (when presented modally)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Recreate your scene")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                // Camera Preview Area
                ZStack {
                    // Camera preview placeholder (will be replaced with actual camera view)
                    Rectangle()
                        .fill(Color.black)
                        .overlay(
                            VStack {
                                // Recording indicator with timer
                                if viewModel.isRecording {
                                    HStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 12, height: 12)
                                        Text(formatDuration(viewModel.recordingDuration))
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                    .padding()
                                } else {
                                    // Status text based on media availability
                                    Text(viewModel.recordedVideoURL != nil || viewModel.selectedImage != nil ? "Media Ready" : "Video Recording")
                                        .foregroundColor(.white)
                                }
                            }
                        )
                    
                    // Camera Controls Overlay
                    VStack {
                        Spacer()
                        HStack {
                            // Gallery upload button
                            Button(action: {
                                viewModel.pickFromGallery()
                            }) {
                                Text("Upload from gallery")
                                    .padding()
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                            
                            // Record/Stop button - Toggles recording state
                            Button(action: {
                                if viewModel.isRecording {
                                    viewModel.stopRecording()
                                } else {
                                    viewModel.startRecording()
                                }
                            }) {
                                Circle()
                                    .fill(viewModel.isRecording ? Color.red : Color.white)
                                    .frame(width: 70, height: 70)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 4)
                                            .frame(width: 60, height: 60)
                                    )
                            }
                            
                            Spacer()
                            
                            // Camera flip button - Switches between front/back camera
                            Button(action: {
                                viewModel.switchCamera()
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.gray.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        
                        // Continue button - Navigates to post preview when media is ready
                        Button(action: {
                            if viewModel.recordedVideoURL != nil || viewModel.selectedImage != nil {
                                showPostPreview = true
                            }
                        }) {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.recordedVideoURL != nil || viewModel.selectedImage != nil ? Color.yellow : Color.gray)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .disabled(viewModel.recordedVideoURL == nil && viewModel.selectedImage == nil)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Capture")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            // Full screen cover for post preview
            .fullScreenCover(isPresented: $showPostPreview) {
                PostPreviewView(
                    mediaURL: viewModel.recordedVideoURL,
                    selectedImage: viewModel.selectedImage
                )
            }
        }
    }
    
    /// Formats a time interval into MM:SS string format
    /// - Parameter duration: Time interval in seconds
    /// - Returns: Formatted string (e.g., "02:30")
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    CaptureView()
}

