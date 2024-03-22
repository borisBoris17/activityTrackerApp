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
    
    @State private var presentedGoals: [Goal] = []
    
    var body: some View {
        
        NavigationStack(path: $presentedGoals) {
            ZStack {
                ScrollView {
                    ForEach(people) { person in
                        HStack() {
                            Text(person.wrappedName)
                                .foregroundColor(.brandColorDark)
                                .font(.title)
                                .fontWeight(.bold)
                            
                        }
                        .padding(.top, 30)
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                if (person.goalsArray.isEmpty) {
                                    AddGoalCardView()
                                } else {
                                    ForEach(person.goalsArray) { goal in
                                        NavigationLink(value: goal) {
                                            GoalCardView(goal: goal, showPerson: false)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
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
            .navigationDestination(for: Goal.self) { goal in
                VStack {
                    GoalDetailView(goal: goal, path: $presentedGoals)
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
                    .foregroundStyle(.brandText)
            }
            .padding()
            .frame(width: 175, height: 175, alignment: .topLeading)
            .background(.brandBackground, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        GoalsView()
    }
}
