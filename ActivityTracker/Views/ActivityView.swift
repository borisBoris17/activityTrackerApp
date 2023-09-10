//
//  ActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/09/2023.
//

import SwiftUI

struct ActivityView: View {
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    
    @State private var name = ""
    @State private var desc = ""
    @State private var selectedPerson = -1
    @State private var selectedGoal = -1
    @State private var numberOfGoals = 1
    
    @State private var startTime =  Date()
    @State private var timerString = "00:00"
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var activityStarted = false
    
    var body: some View {
        NavigationView {
            VStack {
                withAnimation {
                    Text("\(timerString)")
                        .font(.largeTitle.bold())
                }
                
                Button("Start!") {
                    print("Start Activity timer")
                    startTime = Date()
                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                }
                .disabled(disableTimer())
                
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
                                Text("None").tag(-1)
                                ForEach(0 ..< filteredGoals().count, id: \.self) { i in
                                    Text("\(goals[i].wrappedName)")
                                }
                            }
                            .disabled(selectedPerson == -1)
                            
                            if j == numberOfGoals {
                                HStack {
                                    Spacer()
                                    Button("Add Goal") {
                                        numberOfGoals += 1
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }
            }
            .navigationTitle("ActivityTracker")
            .onReceive(timer) { _ in
                let totalSeconds = Int(Date().timeIntervalSince(startTime))
                let seconds = String(format: "%02d", totalSeconds % 60)
                let minutes = String(format: "%02d", totalSeconds / 60)
                let hours = String(format: "%02d", totalSeconds / 3600)
                timerString = hours == "00" ? "\(minutes):\(seconds)" : "\(hours):\(minutes):\(seconds)"
            }
            .onAppear {
                timer.upstream.connect().cancel()
            }
        }
    }
    
    func disableTimer() -> Bool {
        name == "" || desc == "" || selectedPerson == -1
    }
    
    func filteredGoals() -> [Goal] {
        guard selectedPerson != -1 else { return [] }
        
        return goals.filter { goal in
            return goal.person == people[selectedPerson]
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
