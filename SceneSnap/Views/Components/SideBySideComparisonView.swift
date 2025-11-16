//
//  SideBySideComparisonView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct SideBySideComparisonView: View {
    let recreationURL: String
    let originalSceneURL: String?
    let recreationType: Post.MediaType
    let originalType: Post.MediaType?
    
    var body: some View {
        HStack(spacing: 2) {
            // Original Scene (Left)
            if originalSceneURL != nil {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Original")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                        
                        // TODO: Display original scene media
                        // VideoPlayer or Image based on originalType
                    }
                }
            }
            
            // Divider
            if originalSceneURL != nil {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 2)
            }
            
            // Recreation (Right)
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(maxWidth: .infinity)
                
                VStack {
                    Text("Your Recreation")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                    
                    // TODO: Display recreation media
                    // VideoPlayer or Image based on recreationType
                }
            }
        }
        .frame(height: 300)
        .cornerRadius(8)
    }
}

#Preview {
    SideBySideComparisonView(
        recreationURL: "https://example.com/recreation.mp4",
        originalSceneURL: "https://example.com/original.mp4",
        recreationType: .video,
        originalType: .video
    )
}

