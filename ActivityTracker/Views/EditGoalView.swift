//
//  EditGoalView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 05/03/2024.
//

import SwiftUI

struct EditGoalView: View {
    var goal: Goal
    @Binding var newGoalName: String
    @Binding var newGoalDesc: String
    @Binding var newGoalStartDate: Date
    @Binding var newGoalEndDate: Date
    @Binding var newGoalTarget: String
    var saveGoal: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Goal Name") {
                        TextField("Name", text: $newGoalName)
                    }
                    
                    Section("Goal Description") {
                        TextField("Description", text: $newGoalDesc)
                    }
                    
                    Section("Duration") {
                        DatePicker(selection: $newGoalStartDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Start Date")
                        }
                        
                        DatePicker(selection: $newGoalEndDate, in: newGoalStartDate..., displayedComponents: .date) {
                            Text("End Date")
                        }
                    }
                    
                    Section("Target") {
                        TextField("Target (in hours)", text: $newGoalTarget)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Edit Goal")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        saveGoal()
                        dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
//    EditGoalView()
//}
