//
//  PostCardView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Reusable post card component displaying a single post in the feed.
//  Shows media, caption, engagement metrics, and provides interaction buttons.

import SwiftUI

/// Card component displaying a single post in the feed
/// Features:
/// - User profile picture and username (tappable to view profile)
/// - Media display (video or image, with side-by-side comparison if original scene exists)
/// - Caption text
/// - Like, comment, and share buttons
/// - Like and comment counts
/// - Relative timestamp
/// - Comment section sheet
struct PostCardView: View {
    /// The post data to display
    let post: Post
    
    /// Callback when username is tapped (navigates to user profile)
    var onUserTap: (() -> Void)?
    
    /// Controls presentation of comment section sheet
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
                    Button(action: {
                        onUserTap?()
                    }) {
                        Text(post.username)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
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
            Text(post.createdAt.timeAgo())
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

