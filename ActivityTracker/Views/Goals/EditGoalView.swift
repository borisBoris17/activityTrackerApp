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
    
    @State private var goalNameBlankOnSave = false
    @State private var goalTargetBlankOnSave = false
    
    @Environment(\.dismiss) var dismiss
    
    func validateSave() -> Bool {
        var valid = true
        if newGoalName.isEmpty {
            goalNameBlankOnSave = true
            valid = false
        } else {
            goalNameBlankOnSave = false
        }
        if newGoalTarget.isEmpty {
            goalTargetBlankOnSave = true
            valid = false
        } else {
            if let parsedTarget = Int16(newGoalTarget) {
                if parsedTarget >= 0 {
                    goalTargetBlankOnSave = false
                } else {
                    goalTargetBlankOnSave = true
                    valid = false
                }
            } else {
                goalTargetBlankOnSave = true
                valid = false
            }
        }
        return valid
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Name", text: $newGoalName)
                    } header: {
                        Text("Goal Name")
                    } footer: {
                        if goalNameBlankOnSave {
                            Text("Name is required.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(goalNameBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
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
                    
                    Section {
                        TextField("Target (in hours)", text: $newGoalTarget)
                            .keyboardType(.decimalPad)
                    } header: {
                        Text("Target")
                    } footer: {
                        VStack(alignment: .leading) {
                            if goalTargetBlankOnSave {
                                Text("Target is required and must be a positive number.")
                                    .foregroundColor(Color.red)
                            }
                            Text("Enter number of Hours that completes the Goal.")
                        }
                    }
                    .listRowBackground(goalTargetBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    
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
                        if validateSave() {
                            saveGoal()
                            dismiss()
                        }
                    }
                    .padding()
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
