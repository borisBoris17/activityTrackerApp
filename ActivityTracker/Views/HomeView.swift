//
//  HomeView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI


struct HomeView: View {
    @Environment(\.managedObjectContext) var moc
 
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false)]) var activities: FetchedResults<Activity>
    @State private var showAddGoal = false
    @State private var showAddPerson = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Goals")) {
                    if (goals.count == 0) {
                        Text("Add some goals...")
                    }
                    
                    ForEach(goals) { goal in
                        NavigationLink {
                            VStack {
                                GoalDetailView(goal: goal)
                            }
                        } label: {
                            HStack {
                                
                                VStack(alignment: .leading) {
                                    Text(goal.wrappedName)
                                    ForEach(goal.peopleArray) { person in
                                        Text(person.wrappedName)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                                
                                Text("\(goal.formattedProgress)/\(goal.target)")
                            }
                        }
                    }
                    .onDelete(perform: deleteGoals)
                }
                
                Section("Activities") {
                    if (activities.count == 0) {
                        Text("Add some Activities...")
                    }
                    
                    ForEach(activities) { activity in
                        NavigationLink {
                            VStack {
                                ActivityView(activity: activity)
                            }
                        } label: {
                            HStack {
                                
                                VStack(alignment: .leading) {
                                    Text(activity.wrappedName)
                                    Text("\(activity.formattedDuration) hour")
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    ForEach(activity.goalArray) { goal in
                                        ForEach(goal.peopleArray) { person in
                                            Text(person.wrappedName)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteActivities)
                }
            }
            .navigationTitle("ActivityTracker")
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button {
                            showAddPerson = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Person")
                            }
                        }
                        Button {
                            showAddGoal = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Goal")
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddGoal) {
            AddGoalView()
        }
        .sheet(isPresented: $showAddPerson) {
            AddPersonView()
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
    
    func deleteActivities(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let activity = activities[offset]
            for goal in activity.goalArray {
                goal.progress = goal.progress - Double(activity.duration)
            }

            // delete it from the context
            moc.delete(activity)
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
