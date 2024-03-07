//
//  AddGoalToPersonView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 16/02/2024.
//

import SwiftUI

struct AddGoalToPersonView: View {
    var person: Person
    
    @State private var newGoalName = ""
    @State private var newGoalDesc = ""
    @State private var newGoalStartDate = Date.now
    @State private var newGoalTarget = ""
    @State private var newGoalDuration = ""
    @State private var newGoalProgreess = ""
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        
        VStack {
            NavigationView {
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
                    Section("Progress") {
                        TextField("Time already achieved (in hours)", text: $newGoalProgreess)
                            .keyboardType(.decimalPad)
                    }
                }
                .navigationBarItems(leading: Button("Cancel") { dismiss() })
                .navigationBarTitle("Add Goal", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup {
                        
                        Button("Save") {
                            let newGoal = Goal(context: moc)
                            newGoal.id = UUID()
                            newGoal.name = newGoalName
                            newGoal.desc = newGoalDesc
                            newGoal.target = Int16(newGoalTarget) ?? 1000
                            newGoal.startDate = newGoalStartDate
                            newGoal.progress = (Double(newGoalProgreess) ?? 1) * Double(minuteLength) * Double(hourLength)
                            newGoal.people = [person]
                            
                            try? moc.save()
                            
                            dismiss()
                        }
                        .disabled(newGoalName.isEmpty || newGoalTarget.isEmpty)
                        .padding()
                    }
                }
            }
        }
    }
}

//#Preview {
//    AddGoalToPersonView()
//}
