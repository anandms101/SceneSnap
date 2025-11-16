//
//  SceneSnapApp.swift
//  SceneSnap
//
//  Created by Anand Mohan Singh on 11/15/25.
//

import SwiftUI

@main
struct SceneSnapApp: App {
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            if appState.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}
