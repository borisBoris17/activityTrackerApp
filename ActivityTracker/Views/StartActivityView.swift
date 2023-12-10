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
    @Binding var goal: Goal?
    @State private var numberOfGoals = 1
    
    @Binding var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var activityStatus: ActivityStatus
    @Binding var startTime: Date
    
    @State private var selectedPerson = -1
    @State private var selectedGoal = -1
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $desc)
                }
                
                ForEach(1...numberOfGoals, id: \.self) { j in
                    Section {
                        Picker("Person", selection: $selectedPerson) {
                            Text("None").tag(-1)
                            ForEach(0 ..< people.count, id: \.self) { i in
                                Text("\(people[i].wrappedName)").tag(i as Int?)
                            }
                        }
                        
                        Picker("Goal", selection: $selectedGoal) {
                            if filteredGoals().count > 0 {
                                ForEach(0 ..< filteredGoals().count, id: \.self) { i in
                                    Text("\(filteredGoals()[i].wrappedName)")
                                }
                            }
                        }
                        .disabled(selectedPerson == -1)
                    }
                    
                    //                    if j == numberOfGoals {
                    //                        HStack {
                    //                            Spacer()
                    //                            Button("Add Goal") {
                    //                                numberOfGoals += 1
                    //                            }
                    //                        }
                    //                    }
                }
            }
            .navigationTitle("Start New Activity")
            .toolbar {
                ToolbarItem {
                    Button("Start") {
                        goal = filteredGoals()[selectedGoal]
                        activityStatus = .started
                        startTime = Date()
                        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        dismiss()
                    }
                    .disabled(name.isEmpty || desc.isEmpty || selectedGoal == -1)
                    .padding()
                }
            }
            
        }
    }
    
    func filteredGoals() -> [Goal] {
        guard selectedPerson != -1 else { return [] }
        
        return goals.filter { goal in
            return goal.person == people[selectedPerson]
        }
    }
}
