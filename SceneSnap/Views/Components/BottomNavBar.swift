//
//  BottomNavBar.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct BottomNavBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            Button(action: { selectedTab = 0 }) {
                VStack {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
            }
            .foregroundColor(selectedTab == 0 ? .yellow : .gray)
            
            Spacer()
            
            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                    Text("Capture")
                }
            }
            .foregroundColor(.yellow)
            
            Spacer()
            
            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Profile")
                }
            }
            .foregroundColor(selectedTab == 2 ? .yellow : .gray)
        }
        .padding()
        .background(Color.white)
    }
}

#Preview {
    BottomNavBar(selectedTab: .constant(0))
}

