//
//  HomeView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI
import CoreData


struct GoalsView: View {
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var refreshData: RefreshData
    
    @Binding var path: NavigationPath
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Goal.startDate, ascending: false), NSSortDescriptor(keyPath: \Goal.name, ascending: true)]) var goals: FetchedResults<Goal>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Activity.startDate, ascending: false), NSSortDescriptor(keyPath: \Activity.duration, ascending: false)]) var activities: FetchedResults<Activity>
    
    @State private var viewModel = ViewModel()
        
    var body: some View {
        
        NavigationStack(path: $path) {
            ZStack {
                ScrollView {
                    ForEach(people) { person in
                        HStack() {
                            Text(person.wrappedName)
                                .foregroundColor(.brandColorDark)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
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
                                    .id(refreshData.goalRefreshId)
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
                    GoalDetailView(goal: goal, path: $path)
                }
            }
            .navigationDestination(for: Activity.self) { activity in
                ActivityView(activity: activity, path: $path)
            }
            .navigationBarTitle("Goals", displayMode: .inline)
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

//struct HomeView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        GoalsView()
//    }
//}
