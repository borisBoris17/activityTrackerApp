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
    var deleteGoal: (_ goal: Goal) -> Void
    var saveGoal: () -> Void
    @State private var showDeleteAlert = false
    
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
                    
                    Section {
                        Button("Delete") {
                            showDeleteAlert = true
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text("Delete Goal?"),
                                message: Text("This is a permanent action."),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteGoal(goal)
                                    dismiss()
                                },
                                secondaryButton: .cancel())
                        }
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
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
