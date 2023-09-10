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
    @FetchRequest(sortDescriptors: []) var activities: FetchedResults<Activity>
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
                            ScrollView {
                                GoalDetailView(goal: goal)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "tree.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                VStack(alignment: .leading) {
                                    Text(goal.wrappedName)
                                    Text(goal.person?.wrappedName ?? "unknwn person")
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Text("\(goal.progress)/\(goal.target)")
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
                        HStack {
                            Image(systemName: "clock")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            
                            VStack(alignment: .leading) {
                                Text(activity.wrappedName)
                                Text("\(activity.duration) hour")
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                ForEach(activity.goalArray) { goal in
                                    Text("\(goal.person?.wrappedName ?? "unknwn person") - \(goal.wrappedName)")
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
                    Button("Add Data") {
                        add()
                    }
                }
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

            // delete it from the context
            moc.delete(activity)
        }

        // save the context
        try? moc.save()
    }
    
    func add() {
        
        let person1 = Person(context: moc)
        person1.id = UUID()
        person1.name = "Tucker"
        let person2 = Person(context: moc)
        person2.id = UUID()
        person2.name = "Joe"
        let person3 = Person(context: moc)
        person3.id = UUID()
        person3.name = "Mia"
        
        let goal1 = Goal(context: moc)
        goal1.id = UUID()
        goal1.name = "Outside"
        goal1.desc = "Experience the great outdoors"
        goal1.startDate = Date()
        goal1.duration = 1
        goal1.target = 1000
        goal1.progress = 30
        goal1.person = person2

        let goal2 = Goal(context: moc)
        goal2.id = UUID()
        goal2.name = "Outside"
        goal2.desc = "Experience the great outdoors"
        goal2.startDate = Date()
        goal2.duration = 1
        goal2.target = 1000
        goal2.progress = 31
        goal2.person = person3

        let goal3 = Goal(context: moc)
        goal3.id = UUID()
        goal3.name = "Outside"
        goal3.desc = "Experience the great outdoors"
        goal3.startDate = Date()
        goal3.duration = 1
        goal3.target = 1000
        goal3.progress = 31
        goal3.person = person1

        let goal4 = Goal(context: moc)
        goal4.id = UUID()
        goal4.name = "SwiftUI"
        goal4.desc = "Learn Swift to make Apps"
        goal4.startDate = Date()
        goal4.duration = 1
        goal4.target = 1000
        goal4.progress = 100
        goal4.person = person1

        let activity1 = Activity(context: moc)
        activity1.id = UUID()
        activity1.name = "Play Outside"
        activity1.desc = "Play at the park"
        activity1.duration = 1
//        activity1.goals = [goal1]
        activity1.goals = [goal1, goal2, goal3]

        let activity2 = Activity(context: moc)
        activity2.id = UUID()
        activity2.name = "Play"
        activity2.desc = "Play in the yard"
        activity2.duration = 1
        activity2.goals = [goal1, goal3]

        let activity3 = Activity(context: moc)
        activity3.id = UUID()
        activity3.name = "Play"
        activity3.desc = "Play in the yard"
        activity3.duration = 1
        activity3.goals = [goal4]
//
//        goal1.activities = [activity1]
        goal1.activities = [activity1, activity2]
        goal2.activities = [activity1]
        goal3.activities = [activity1, activity2]
        goal4.activities = [activity3]
        
        do {
            try moc.save()
        } catch {
            print("There was an error saving \(error.localizedDescription)")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        HomeView()
    }
}
