//
//  MainTabView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            CaptureView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Capture")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(.yellow)
    }
}

#Preview {
    MainTabView()
}

