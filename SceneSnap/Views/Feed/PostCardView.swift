//
//  PostCardView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    @State private var showComments: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                // Profile Picture
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading) {
                    Text(post.username)
                        .fontWeight(.semibold)
                    if !post.challengeTag.isEmpty {
                        Text(post.challengeTag)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Media Display
            if post.originalSceneURL != nil {
                // Side-by-side comparison view
                SideBySideComparisonView(
                    recreationURL: post.mediaURL,
                    originalSceneURL: post.originalSceneURL,
                    recreationType: post.mediaType,
                    originalType: post.originalMediaType
                )
                .padding(.horizontal)
            } else {
                // Single media display
                // TODO: Implement video/image display
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(
                        Text(post.mediaType == .video ? "Video" : "Photo")
                            .foregroundColor(.secondary)
                    )
            }
            
            // Caption
            if !post.caption.isEmpty {
                Text(post.caption)
                    .padding(.horizontal)
            }
            
            // Interaction Bar
            HStack(spacing: 20) {
                Button(action: {
                    // TODO: Implement like
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                }
                
                Text("\(post.likeCount)")
                
                Button(action: {
                    showComments.toggle()
                }) {
                    Image(systemName: "bubble.right")
                }
                
                Text("\(post.commentCount)")
                
                Spacer()
                
                Button(action: {
                    // TODO: Implement share
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .padding(.horizontal)
            
            // Timestamp
            Text("2h ago") // TODO: Calculate relative time
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color.white)
        .sheet(isPresented: $showComments) {
            CommentSectionView(postId: post.id)
        }
    }
}

#Preview {
    PostCardView(post: Post(
        id: "1",
        userId: "user1",
        username: "testuser",
        mediaURL: "https://example.com",
        mediaType: .video
    ))
}

