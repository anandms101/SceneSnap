//
//  CommentSectionView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct CommentSectionView: View {
    let postId: String
    @State private var comments: [Comment] = []
    @State private var newComment: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                // Comments List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 15) {
                        ForEach(comments) { comment in
                            HStack(alignment: .top, spacing: 10) {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(comment.username)
                                        .fontWeight(.semibold)
                                    Text(comment.text)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        if comments.isEmpty {
                            Text("No comments yet")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                    .padding(.vertical)
                }
                
                // Comment Input
                HStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                    
                    TextField("Add a comment...", text: $newComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if !newComment.isEmpty {
                            // Create new comment
                            let comment = Comment(
                                id: UUID().uuidString,
                                postId: postId,
                                userId: AppState.shared.currentUser?.id ?? "unknown",
                                username: AppState.shared.currentUser?.username ?? "User",
                                text: newComment
                            )
                            comments.append(comment)
                            newComment = ""
                        }
                    }) {
                        Text("Post")
                            .foregroundColor(newComment.isEmpty ? .gray : .blue)
                    }
                    .disabled(newComment.isEmpty)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            // TODO: Fetch comments from Firestore
            // For now, show empty state
        }
    }
}

#Preview {
    CommentSectionView(postId: "post1")
}

