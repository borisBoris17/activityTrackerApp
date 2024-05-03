//
//  GoalDetailView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/08/2023.
//

import SwiftUI
import CoreData

struct GoalDetailView: View {
    let goal: Goal
    @Binding var path: NavigationPath
    
    @State private var viewModel = ViewModel()
    
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var refreshData: RefreshData
    
    let animation = Animation
        .easeOut(duration: 1)
        .delay(0.25)
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            ZStack {
                                Circle()
                                    .stroke(.primary.opacity(0.5), lineWidth: 20)
                                    .frame(width: geometry.size.width * 0.7,
                                           height: geometry.size.width * 0.7)
                                
                                Circle()
                                    .trim(from: 0,
                                          to: viewModel.drawingStroke ?
                                          goal.percentageDone
                                          : 0)
                                    .stroke(
                                        Color.brand,
                                        style: StrokeStyle(
                                            lineWidth: 20,
                                            lineCap: .round
                                        )
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .animation(animation, value: viewModel.drawingStroke)
                                    .frame(width: geometry.size.width * 0.7,
                                           height: geometry.size.width * 0.7)
                                
                                
                                Text("\(goal.formattedProgress) / \(goal.target)")
                                    .font(.largeTitle.bold())
                                
                            }
                            .padding(.vertical)
                        }
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(goal.wrappedName )
                                .font(.title.bold())
                                .foregroundStyle(.brandColorDark)
                            if !goal.peopleArray.isEmpty {
                                Text("Person: \(goal.peopleArray[0].wrappedName)")
                                    .foregroundStyle(.brandMediumLight)
                                    .fontWeight(.bold)
                            } else {
                                Text("Unknown Person")
                                    .foregroundStyle(.brandMediumLight)
                                    .fontWeight(.bold)
                            }
                            
                            Text(goal.wrappedDesc)
                                .foregroundStyle(.brandMediumLight)
                            
                            Text("Progress: \(goal.formattedHrsMinsProgress)")
                                .foregroundStyle(.brandMediumLight)
                            
                            Text("Starting: \(goal.formattedStartDate)")
                                .foregroundStyle(.brandMediumLight)
                            
                            Text("Remaining Days: \(goal.daysBetween)")
                                .foregroundStyle(.brandMediumLight)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    if (goal.descendingActivityArray.count > 0) {
                        VStack(alignment: .leading) {
                            Text("Activities")
                                .font(.title.bold())
                                .foregroundStyle(.brandColorDark)
                            
                            ForEach(goal.descendingActivityArray) {activity in
                                NavigationLink(value: activity) {
                                    ActivityCardView(activity: activity, geometry: geometry)
                                        .padding(.bottom)
                                }
                            }
                            .id(refreshData.activityRefreshId)
                        }
                        .padding()
                    }
                    
                }
                Spacer()
            }
        }
        .navigationTitle(!viewModel.isDelete ? goal.peopleArray[0].wrappedName : "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button("Edit") {
                    viewModel.prepareForEdit(for: goal)
                }
            }
        }
        .onAppear {
            viewModel.drawingStroke = true
        }
        .sheet(isPresented: $viewModel.showEditGoal) {
            EditGoalView(goal: goal, newGoalName: $viewModel.newGoalName, newGoalDesc: $viewModel.newGoalDesc, newGoalStartDate: $viewModel.newGoalStartDate, newGoalEndDate: $viewModel.newGoalEndDate, newGoalTarget: $viewModel.newGoalTarget, deleteGoal: deleteGoal) {
                viewModel.update(goal)
                
                try? moc.save()
                refreshData.goalRefreshId = UUID()
                refreshData.activityRefreshId = UUID()
            }
        }
    }
    
    func deleteGoal(goal: Goal) {
        path.removeLast()
        viewModel.isDelete = true
        for activity in goal.activityArray {
            if activity.goalArray.count == 1 && activity.goalArray.contains(goal) {
                moc.delete(activity)
            }
        }
        
        // delete it from the context
        moc.delete(goal)
        
        try? moc.save()
        refreshData.goalRefreshId = UUID()
        refreshData.activityRefreshId = UUID()
    }
}

//struct GoalDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalDetailView()
//    }
//}
