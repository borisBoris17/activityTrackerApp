//
//  ActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 09/09/2023.
//

import SwiftUI
import PhotosUI

struct ActivityView: View {
    
    let activity: Activity
    @Binding var path: NavigationPath
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = ViewModel()
    
    @Environment(\.displayScale) var displayScale
    
    @EnvironmentObject var refreshData: RefreshData
    
    func deleteActivity(activity: Activity) {
        path.removeLast()
        for goal in activity.goalArray {
            goal.progress = goal.progress - Double(activity.duration)
        }
        moc.delete(activity)
        
        try? moc.save()
        refreshData.goalRefreshId = UUID()
        refreshData.activityRefreshId = UUID()
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .top) {
                    NavigationLink {
                        VStack {
                            viewModel.activityImage?
                                .resizable()
                                .scaledToFit()
                        }
                    } label: {
                        HStack {
                            viewModel.activityImage?
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.45)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(activity.wrappedName)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.brandColorDark)
                        
                        Text("\(activity.formattedHrsMinsDuration)")
                            .foregroundStyle(.brandMediumLight)
                        
                        Text(activity.formattedStartDate)
                            .foregroundStyle(.brandMediumLight)
                            .font(.footnote)
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack {
                    HStack {
                        Text("Description")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.brandColorDark)
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    Text(activity.wrappedDesc)
                        .foregroundStyle(.brandMediumLight)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                .padding()
                
                VStack {
                    HStack {
                        Text("Goals")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.brandColorDark)
                        
                        Spacer()
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(activity.goalArray) { goal in
                                NavigationLink(value: goal) {
                                    GoalCardView(goal: goal, showPerson: true)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .id(refreshData.goalRefreshId)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .padding()
                
                Spacer()
            }
            .padding(.top)
            .navigationBarTitle("Activity Detail", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup {
                    if viewModel.mode == "view" {
                        Button("Edit") {
                            viewModel.prepareEdit(for: activity)
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId).png")
                viewModel.activityImage = Utils.loadImage(from: imagePath)
            }
            .sheet(isPresented: $viewModel.showEditActivity) {
                EditActivityView(activity: activity, geometry: geometry, newActivityName: $viewModel.updatedName, newActivityDesc: $viewModel.updatedDescription, newActivityGoals: $viewModel.updatedGoals, newActivityPhotoItem: $viewModel.activityPhotoItem, newActivityImageData: $viewModel.activityImageData, newActivityImage: $viewModel.activityImage, newActivityMinutes: $viewModel.minutes, newActivityHours: $viewModel.hours, deleteActivity: deleteActivity) {
                    viewModel.edit(for: activity)
                    try? moc.save()
                    refreshData.goalRefreshId = UUID()
                    refreshData.activityRefreshId = UUID()
                }
            }
        }
    }
    
}

//struct ActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(activity: Activity)
//    }
//}
