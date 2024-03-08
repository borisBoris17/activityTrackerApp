//
//  HomeView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI


struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false)]) var activities: FetchedResults<Activity>
    @State private var showAddGoal = false
    @State private var showAddPerson = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                List {
                    
                    if (goals.count == 0) {
                        Text("Add some goals...")
                    }
                    
                    ForEach(people) { person in
                        if person.goalsArray.count > 0 {
                        Section(person.wrappedName) {
                                ForEach(person.goalsArray) { goal in
                                    if goal.peopleArray.contains(person) {
                                        NavigationLink {
                                            VStack {
                                                GoalDetailView(goal: goal)
                                            }
                                        } label: {
                                            HStack {
                                                
                                                VStack(alignment: .leading) {
                                                    Text(goal.wrappedName)
                                                    Text(goal.wrappedDesc)
                                                        .foregroundColor(.secondary)
                                                }
                                                
                                                Spacer()
                                                
                                                Text("\(goal.formattedProgress)/\(goal.target)")
                                            }
                                        }
                                    }
                                }
                                .onDelete(perform: deleteGoals)
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button() {
                            showAddGoal = true
                        } label : {
                            Label("Add New Goal", systemImage: "plus")
                        }
                        .buttonStyle(BlueButton())
                    }
                }
            }
            .navigationTitle("Goals")
            .sheet(isPresented: $showAddGoal) {
                AddGoalView()
            }
        }
    }
    
    func deleteGoals(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let goal = goals[offset]
            
            for activity in activities {
                if activity.goalArray.count == 1 && activity.goalArray.contains(goal) {
                    moc.delete(activity)
                }
            }
            
            // delete it from the context
            moc.delete(goal)
        }
        
        // save the context
        try? moc.save()
    }
    
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}
