//
//  LeaderboardView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//
//  Leaderboard screen displaying top posts for the current weekly challenge.
//  Shows rankings based on like count with navigation to capture screen.

import SwiftUI

/// Leaderboard screen for current weekly challenge
/// Features:
/// - Current challenge title display
/// - Ranked list of top posts by like count
/// - Pull-to-refresh functionality
/// - "Join Challenge" button to navigate to capture screen
/// - Empty state when no entries available
struct LeaderboardView: View {
    /// ViewModel managing leaderboard data
    @StateObject private var viewModel = LeaderboardViewModel()
    
    /// Environment value for dismissing the view
    @Environment(\.dismiss) var dismiss
    
    /// Controls presentation of capture screen
    @State private var showCapture: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let challenge = viewModel.currentChallenge {
                    Text(challenge.title)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.top)
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
                    showCapture = true
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
            .navigationTitle("Leaderboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showCapture) {
                CaptureView()
            }
        }
    }
}

#Preview {
    LeaderboardView()
}

