//
//  AddGoalView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI
import MultiPicker

struct AddGoalView: View {
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    @State private var newGoalName = ""
    @State private var newGoalDesc = ""
    @State private var newGoalPerson = -1
    @State private var newGoalStartDate = Date.now
    @State private var newGoalTarget = ""
    @State private var newGoalDuration = ""
    @State private var newGoalProgreess = ""
    @State private var newGoalPeople: Set<Person> = []
    
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
                        Picker("Who's Goal?", selection: $newGoalPerson) {
                            Text("None").tag(-1)
                            ForEach(0 ..< people.count, id: \.self) { i in
                                Text("\(people[i].wrappedName)")
                            }
                        }
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
                .navigationTitle("Add Goal")
                .toolbar {
                    ToolbarItemGroup {
                        
                        Button("Save") {
                            let newGoal = Goal(context: moc)
                            newGoal.id = UUID()
                            newGoal.name = newGoalName
                            newGoal.desc = newGoalDesc
                            newGoal.target = Int16(newGoalTarget) ?? 1000
                            newGoal.startDate = newGoalStartDate
                            newGoal.progress = Int16(newGoalProgreess) ?? 0
                            newGoal.people = [people[newGoalPerson]]
                            newGoal.duration = Int16(newGoalDuration) ?? 1
                            
                            try? moc.save()
                            
                            dismiss()
                        }
                        .disabled(newGoalName.isEmpty || newGoalPerson == -1 || newGoalTarget.isEmpty)
                        .padding()
                    }
                }
            }
        }
    }
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView()
    }
}
