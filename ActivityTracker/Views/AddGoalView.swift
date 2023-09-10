//
//  AddGoalView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI

struct AddGoalView: View {
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    @State private var newGoalName = ""
    @State private var newGoalDesc = ""
    @State private var newGoalPerson = 0
    @State private var newGoalStartDate = Date.now
    @State private var newGoalTarget = ""
    @State private var newGoalProgreess = ""
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        
        VStack {
            NavigationView {
                Form {
                    Section {
                        TextField("Name", text: $newGoalName)
                        TextField("Description", text: $newGoalDesc)
                    }
                    
                    Section {
                        Picker("Person", selection: $newGoalPerson) {
                            ForEach(0 ..< people.count, id: \.self) { i in
                                Text("\(people[i].wrappedName)")
                            }
                        }
                        
                        DatePicker(selection: $newGoalStartDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Start Date")
                        }
                        TextField("Target", text: $newGoalTarget)
                            .keyboardType(.decimalPad)
                        TextField("Progress", text: $newGoalProgreess)
                            .keyboardType(.decimalPad)
                    }
                    
                    Button {
                        
                        let newGoal = Goal(context: moc)
                        newGoal.id = UUID()
                        newGoal.name = newGoalName
                        newGoal.desc = newGoalDesc
                        newGoal.target = Int16(newGoalTarget) ?? 1000
                        newGoal.startDate = newGoalStartDate
                        newGoal.progress = Int16(newGoalProgreess) ?? 0
                        newGoal.person = people[newGoalPerson]
                        newGoal.duration = 1
                        
                        try? moc.save()
                        
                        dismiss()
                    } label: {
                        HStack {
                            Text("Save Goal")
                            Image(systemName: "doc.badge.plus")
                        }
                    }
                }
                .navigationTitle("Add Goal")
            }
        }
    }
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView()
    }
}
