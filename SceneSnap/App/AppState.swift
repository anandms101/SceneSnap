//
//  AppState.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import Foundation
import Combine

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    static let shared = AppState()
    
    private init() {}
}

