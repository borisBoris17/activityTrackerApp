//
//  EditGoalView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 05/03/2024.
//

import SwiftUI

struct EditGoalView: View {
    @Binding var newGoalName: String
    @Binding var newGoalDesc: String
    @Binding var newGoalStartDate: Date
    @Binding var newGoalTarget: String
    // Update when refactored to be an endDate
    @Binding var newGoalDuration: String
    var saveGoal: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Goal Name") {
                        TextField("Name", text: $newGoalName)
                    }
                    
                    Section("Goal Description") {
                        TextField("Description", text: $newGoalDesc)
                    }
                    
                    Section {
                        DatePicker(selection: $newGoalStartDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Start Date")
                        }
                    }
                    
                    Section("Target") {
                        TextField("Target (in hours)", text: $newGoalTarget)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section("Duration") {
                        TextField("Time to achieve goal (in years)", text: $newGoalDuration)
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
