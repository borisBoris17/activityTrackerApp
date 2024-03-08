//
//  StartActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/09/2023.
//

import SwiftUI
import Combine

struct StartActivityView: View {
    @Binding var name: String
    @Binding var desc: String
    @Binding var goals: [Goal]
    
    @Binding var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var activityStatus: ActivityStatus
    @Binding var startTime: Date

    @State private var selectedGoals = Set<Goal>()
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var allGoals: FetchedResults<Goal>
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Name", text: $name)
                        TextField("Description", text: $desc)
                    }
                    
                    Section("Goals") {
                        GoalSelectionView(selectedGoals: $selectedGoals)
                    }
                }
            }
            .navigationTitle("Start New Activity")
            .toolbar {
                ToolbarItem {
                    Button("Start") {
                        goals = Array(selectedGoals)
                        activityStatus = .started
                        startTime = Date()
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        dismiss()
                    }
                    .disabled(name.isEmpty || desc.isEmpty || selectedGoals.count < 1)
                    .padding()
                }
            }
        }
    }
}
