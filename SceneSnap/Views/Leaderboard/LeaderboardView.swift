//
//  LeaderboardView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var viewModel = LeaderboardViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Leaderboard")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                if viewModel.currentChallenge != nil {
                    Text("<Title of weekly challenge>")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                }
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(viewModel.entries.enumerated()), id: \.element.id) { index, entry in
                            LeaderboardRowView(entry: entry, rank: index + 1)
                        }
                        
                        if viewModel.entries.isEmpty {
                            Text("No entries yet")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await viewModel.refreshLeaderboard()
                }
                
                Spacer()
                
                Button(action: {
                    // TODO: Navigate to CaptureView
                }) {
                    Text("Join Challenge")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}

#Preview {
    LeaderboardView()
}

