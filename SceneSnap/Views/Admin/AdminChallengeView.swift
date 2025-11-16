//
//  AdminChallengeView.swift
//  SceneSnap
//
//  Created by SceneSnap Team
//

import SwiftUI

struct AdminChallengeView: View {
    @StateObject private var viewModel = AdminChallengeViewModel()
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var tag: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(7 * 24 * 60 * 60)
    
    var body: some View {
        NavigationView {
            Form {
                Section("Challenge Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Tag (e.g., RomComWeek)", text: $tag)
                }
                
                Section("Schedule") {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section {
                    Button(action: {
                        // TODO: Create challenge
                    }) {
                        Text("Create Challenge")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.yellow)
                }
            }
            .navigationTitle("Create Challenge")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AdminChallengeView()
}

