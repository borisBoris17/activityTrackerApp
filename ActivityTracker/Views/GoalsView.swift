//
//  HomeView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI


struct GoalsView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: []) var goals: FetchedResults<Goal>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false)]) var activities: FetchedResults<Activity>
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                ScrollView {
                    ForEach(people) { person in
                        HStack() {
                            Text(person.wrappedName)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.top, 50)
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                if (person.goalsArray.isEmpty) {
                                    AddGoalCardView()
                                } else {
                                    ForEach(person.goalsArray) { goal in
                                        NavigationLink {
                                            VStack {
                                                GoalDetailView(goal: goal)
                                            }
                                        } label: {
                                            GoalCardView(goal: goal)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .scrollIndicators(.hidden)
//                List {
//                    
//                    if (goals.count == 0) {
//                        Text("Add some goals...")
//                    }
//                    
//                    ForEach(people) { person in
//                        if person.goalsArray.count > 0 {
//                        Section(person.wrappedName) {
//                                ForEach(person.goalsArray) { goal in
//                                    if goal.peopleArray.contains(person) {
//                                        NavigationLink {
//                                            VStack {
//                                                GoalDetailView(goal: goal)
//                                            }
//                                        } label: {
//                                            HStack {
//                                                
//                                                VStack(alignment: .leading) {
//                                                    Text(goal.wrappedName)
//                                                    Text(goal.wrappedDesc)
//                                                        .foregroundColor(.secondary)
//                                                }
//                                                
//                                                Spacer()
//                                                
//                                                Text("\(goal.formattedProgress)/\(goal.target)")
//                                            }
//                                        }
//                                    }
//                                }
//                                .onDelete(perform: deleteGoals)
//                            }
//                        }
//                    }
//                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button() {
                            viewModel.showAddGoal = true
                        } label : {
                            Label("Add New Goal", systemImage: "plus")
                        }
                        .buttonStyle(BlueButton())
                    }
                }
            }
            
            .navigationTitle("Goals")
            .sheet(isPresented: $viewModel.showAddGoal) {
                AddGoalView()
            }
        }
    }
    
    struct AddGoalCardView: View {
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Add a goal")
                    .font(.title)
            }
            .padding()
            .frame(width: 165, height: 165, alignment: .topLeading)
            .background(.secondary, in: RoundedRectangle(cornerRadius: 16))
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
        GoalsView()
    }
}
