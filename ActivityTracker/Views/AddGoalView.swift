//
//  AddGoalView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI
import MultiPicker

//let minuteLength: Int16 = 3
//let hourLength: Int16 = 3

struct AddGoalView: View {
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    @State private var newGoalName = ""
    @State private var newGoalDesc = ""
    @State private var newGoalPerson = -1
    @State private var newGoalStartDate = Date.now
    @State private var newGoalEndDate = Calendar.current.date(byAdding: .year, value: 1, to: Date.init())!
    @State private var newGoalTarget = ""
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
                    
                    Section("Duration") {
                        DatePicker(selection: $newGoalStartDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Start Date")
                        }
                        
                        DatePicker(selection: $newGoalEndDate, in: Date.now..., displayedComponents: .date) {
                            Text("End Date")
                        }
                    }
                    
                    Section("Target") {
                        TextField("Target (in hours)", text: $newGoalTarget)
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
                            newGoal.endDate = newGoalEndDate
                            newGoal.progress = (Double(newGoalProgreess) ?? 1) * Double(minuteLength) * Double(hourLength)
                            newGoal.people = [people[newGoalPerson]]
                            
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
