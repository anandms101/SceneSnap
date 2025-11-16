//
//  FeedView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Weekly Challenge Banner
                    if let challenge = viewModel.currentChallenge {
                        WeeklyChallengeBanner(challenge: challenge)
                            .padding(.horizontal)
                    }
                    
                    // Posts
                    ForEach(viewModel.posts) { post in
                        PostCardView(post: post)
                    }
                    
                    if viewModel.posts.isEmpty {
                        Text("No posts yet")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.refreshFeed()
            }
            .navigationTitle("SceneSnap")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FeedView()
}

