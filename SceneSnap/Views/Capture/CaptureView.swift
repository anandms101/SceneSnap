//
//  CaptureView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct CaptureView: View {
    @StateObject private var viewModel = CaptureViewModel()
    @State private var showPostPreview: Bool = false
    
    var body: some View {
        VStack {
            Text("Recreate your scene")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()
            
            // Camera Preview Area
            ZStack {
                // TODO: Implement camera preview
                Rectangle()
                    .fill(Color.black)
                    .overlay(
                        Text("Video Recording")
                            .foregroundColor(.white)
                    )
                
                // Record Button
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            // TODO: Navigate to post preview
                            showPostPreview = true
                        }) {
                            Text("Continue")
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .disabled(viewModel.recordedVideoURL == nil && viewModel.selectedImage == nil)
                        
                        Spacer()
                        
                        // Camera Flip Button
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
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.pickFromGallery()
                        }) {
                            Text("upload from gallery")
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showPostPreview) {
            PostPreviewView()
        }
    }
}

#Preview {
    CaptureView()
}

