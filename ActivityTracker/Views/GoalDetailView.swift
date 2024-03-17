//
//  GoalDetailView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/08/2023.
//

import SwiftUI

struct GoalDetailView: View {
    let goal: Goal
    
    @State private var viewModel = ViewModel()
    
    @Environment(\.managedObjectContext) var moc
    
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
                                NavigationLink {
                                    ActivityView(activity: activity, refreshId: $viewModel.refreshId)
                                } label: {
                                    ActivityCardView(activity: activity, geometry: geometry)
                                        .padding(.bottom)
                                }
                            }
                            .id(viewModel.refreshId)
                        }
                        .padding()
                    }

                }
                Spacer()
            }
            .sheet(isPresented: $viewModel.showActivities) {
                NavigationStack {
                    
                }
                .presentationDetents([.height(geometry.size.height * 0.45), .medium, .large])
            }
        }
        .navigationTitle(goal.peopleArray[0].wrappedName)
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
            EditGoalView(goal: goal, newGoalName: $viewModel.newGoalName, newGoalDesc: $viewModel.newGoalDesc, newGoalStartDate: $viewModel.newGoalStartDate, newGoalEndDate: $viewModel.newGoalEndDate, newGoalTarget: $viewModel.newGoalTarget) {
                viewModel.update(goal)
                
                try? moc.save()
            }
        }
    }
}

//struct GoalDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalDetailView()
//    }
//}
