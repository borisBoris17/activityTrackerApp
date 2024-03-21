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
                                .foregroundColor(.brandColorDark)
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                            Button {
                                viewModel.personToAddGoal = person
                                viewModel.showAddGoal = true
                            } label: {
                                Image(systemName: "plus")
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .foregroundStyle(.brandColorDark)
                            }
                        }
                        .padding(.top, 30)
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                if (person.goalsArray.isEmpty) {
                                    AddGoalCardView()
//                                    Button {
//                                        viewModel.personToAddGoal = person
//                                        viewModel.showAddGoal = true
//                                    } label: {
//                                        HStack {
//                                            Spacer()
//                                            Image(systemName: "plus")
//                                                .resizable()
//                                                .padding()
//                                                .scaledToFit()
//                                                .foregroundStyle(.brandText)
//                                            Spacer()
//                                        }
//                                        .padding()
//                                        .frame(width: 175, height: 175)
//                                        .background(.brandBackground, in: RoundedRectangle(cornerRadius: 16))
//                                    }
                                } else {
                                    ForEach(person.goalsArray) { goal in
                                        NavigationLink {
                                            VStack {
                                                GoalDetailView(goal: goal)
                                            }
                                        } label: {
                                            GoalCardView(goal: goal, showPerson: false)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    
//                                    Button {
//                                        viewModel.personToAddGoal = person
//                                        viewModel.showAddGoal = true
//                                    } label: {
//                                        HStack {
//                                            Spacer()
//                                            Image(systemName: "plus")
//                                                .resizable()
//                                                .padding()
//                                                .scaledToFit()
//                                                .foregroundStyle(.brandText)
//                                            Spacer()
//                                        }
//                                        .padding()
//                                        .frame(width: 175, height: 175)
//                                        .background(.brandBackground, in: RoundedRectangle(cornerRadius: 16))
//                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                .padding(.horizontal)
                .background(.neutralLight)
                .scrollIndicators(.hidden)
                
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
                if let person = viewModel.personToAddGoal {
                    AddGoalToPersonView(person: person)
                }
            }
        }
    }
    
    struct AddGoalCardView: View {
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Add a goal")
                    .font(.title)
                    .foregroundStyle(.brandText)
            }
            .padding()
            .frame(width: 175, height: 175, alignment: .topLeading)
            .background(.brandBackground, in: RoundedRectangle(cornerRadius: 16))
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
