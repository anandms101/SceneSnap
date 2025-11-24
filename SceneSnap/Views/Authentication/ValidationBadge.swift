//
//  ValidationBadge.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct ValidationBadge: View {
    let state: ValidationState
    
    private var iconName: String {
        switch state.status {
        case .idle:
            return "info.circle"
        case .valid:
            return "checkmark.seal.fill"
        case .invalid:
            return "exclamationmark.triangle.fill"
        }
    }
    
    private var tint: Color {
        switch state.status {
        case .idle:
            return Color.gray.opacity(0.6)
        case .valid:
            return Color.green
        case .invalid:
            return Color.red
        }
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .font(.footnote)
                .foregroundColor(.white)
                .padding(6)
                .background(tint)
                .clipShape(Circle())
            
            Text(state.message)
                .font(.footnote)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
        }
        .padding(10)
        .background(tint.opacity(0.15))
        .cornerRadius(10)
    }
}

#Preview {
    VStack(spacing: 12) {
        ValidationBadge(state: ValidationState(status: .idle, message: "Enter email."))
        ValidationBadge(state: ValidationState(status: .valid, message: "Looks good!"))
        ValidationBadge(state: ValidationState(status: .invalid, message: "Fix errors."))
    }
    .padding()
}
