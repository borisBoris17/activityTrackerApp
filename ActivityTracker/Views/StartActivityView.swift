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
    @State private var numberOfGoals = 2
    
    @Binding var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var activityStatus: ActivityStatus
    @Binding var startTime: Date
    
    @State private var selectedPeople = Set<Person>()
    @State private var selectedGoals = Set<Goal>()
    
    @State private var selectedPerson = -1
    @State private var selectedGoal = -1
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var allGoals: FetchedResults<Goal>
    @State var peopleArray = [Person]()
    @State var goalsArray = [Goal]()
    @State private var isPersonChecked = [Bool]()
    @State private var isChecked = false
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Description", text: $desc)
                }
                
                MultiSelector(
                    label: Text("People"),
                    options: peopleArray,
                    optionToString: { $0.wrappedName },
                    selected: $selectedPeople
                )
                
                Section("Goals") {
                    MultiSelector(
                        label: Text("Goals"),
                        options: goalsArray,
                        optionToString: { $0.wrappedName },
                        selected: $selectedGoals
                    )
                    
//                    ForEach(selectedPeople.sorted(by: <), id: \.self) {thisPerson in
//                        if !thisPerson.goalsArray.isEmpty {
//                            ForEach(0 ..< thisPerson.goalsArray.count, id: \.self) { j in
//                                HStack {
//                                    Toggle(isOn: $isChecked) {
//                                        Text("\(thisPerson.goalsArray[j].wrappedName)")
//                                        Text("\(thisPerson.goalsArray[j].wrappedDesc)")
//                                    }
//                                }
//                            }
//                        }
//                    }
                }
            }
            .onChange(of: selectedPeople) { newValue in
                print("onChange")
                goalsArray = allGoals.filter { goal in
                    var goalHasPerson = false
                    for person in selectedPeople {
                        goalHasPerson = goal.peopleArray.contains { element in
                            element == person
                        }
                        if goalHasPerson {
                            break
                        }
                    }
                    return goalHasPerson
                }
                print("Goals array: \(goalsArray)")
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
            .onAppear() {
                print("onAppear")
                peopleArray = Array(people)
            }
        }
    }
}
