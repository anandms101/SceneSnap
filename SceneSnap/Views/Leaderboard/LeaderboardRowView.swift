//
//  LeaderboardRowView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct LeaderboardRowView: View {
    let entry: LeaderboardEntry
    let rank: Int
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank
            Text("\(rank)")
                .font(.title2)
                .fontWeight(.bold)
                .frame(width: 40)
            
            // Profile Picture
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
            
            // Username
            Text(entry.username)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Like Count
            HStack(spacing: 5) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("\(entry.likeCount)")
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    LeaderboardRowView(
        entry: LeaderboardEntry(
            id: "1",
            userId: "user1",
            username: "testuser",
            postMediaURL: "https://example.com",
            likeCount: 42,
            postId: "post1"
        ),
        rank: 1
    )
}

