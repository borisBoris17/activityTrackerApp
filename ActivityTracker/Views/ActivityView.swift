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
    @Binding var refreshId: UUID
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = ViewModel()
    
    @Environment(\.displayScale) var displayScale
    
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
                        
                        Text("\(activity.formattedDuration) hrs")
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
                                NavigationLink {
                                    VStack {
                                        GoalDetailView(goal: goal)
                                    }
                                } label: {
                                    GoalCardView(goal: goal, showPerson: true)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                .padding()
                
                Spacer()
            }
            
            //            Form {
            //                HStack(alignment: .top) {
            //                    if viewModel.mode == "view" {
            //                        Text("Name")
            //                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
            //                        Spacer()
            //                        Text(activity.wrappedName)
            //                            .foregroundColor(.secondary)
            //                            .multilineTextAlignment(.trailing)
            //                    } else {
            //                        Text("Name")
            //                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
            //                        Spacer()
            //                        TextField("Name", text: $viewModel.updatedName)
            //                            .multilineTextAlignment(.trailing)
            //                            .background(Color.secondary)
            //                    }
            //                }
            //
            //                HStack(alignment: .top) {
            //                    if viewModel.mode == "view" {
            //                        Text("Description")
            //                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
            //                        Spacer()
            //                        Text(activity.wrappedDesc)
            //                            .foregroundColor(.secondary)
            //                            .multilineTextAlignment(.trailing)
            //                    } else {
            //                        Text("Description")
            //                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
            //                        Spacer()
            //                        TextEditor( text: $viewModel.updatedDescription)
            //                            .frame(minHeight: 150,
            //                                   maxHeight: .infinity,
            //                                   alignment: .center )
            //                            .multilineTextAlignment(.trailing)
            //                            .background(Color.secondary)
            //                    }
            //                }
            //
            //                HStack {
            //                    if viewModel.mode == "view" {
            //                        NavigationLink {
            //                            VStack {
            //                                viewModel.activityImage?
            //                                    .resizable()
            //                                    .scaledToFit()
            //                            }
            //                        } label: {
            //                            HStack {
            //                                viewModel.activityImage?
            //                                    .resizable()
            //                                    .scaledToFit()
            //                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
            //                            }
            //                        }
            //                    } else {
            //                        ImagePickerView(photoItem: $viewModel.activityPhotoItem, selectedImageData: $viewModel.activityImageData, imageSize: geometry.size.width * 0.15)
            //                            .onChange(of: viewModel.activityImageData) {
            //                                if let activityImageData = viewModel.activityImageData,
            //                                   let uiImage = UIImage(data: activityImageData) {
            //                                    viewModel.activityImage = Image(uiImage: uiImage)
            //                                }
            //                            }
            //                    }
            //                }
            //
            //
            //                HStack() {
            //                    if viewModel.activityImage != nil && viewModel.mode == "edit" {
            //                        Button("Remove Image", role: .destructive) {
            //                            viewModel.removeActivityImage(on: activity)
            //                        }
            //                    }
            //                }
            //
            //                HStack(alignment: .top) {
            //                    VStack(alignment: .lesading) {
            //                        Text("Goals")
            //                        if viewModel.mode == "edit" {
            //                            Button("Edit") {
            //                                viewModel.showEditGoals.toggle()
            //                            }
            //                        }
            //                    }
            //                    .frame(width: geometry.size.width * 0.3, alignment: .leading)
            //                    Spacer()
            //                    VStack(alignment: .trailing) {
            //                        ForEach(activity.goalArray) { goal in
            //                            ForEach(goal.peopleArray) { person in
            //                                Text("\(person.wrappedName) - \(goal.wrappedName)" )
            //                                    .foregroundColor(.secondary)
            //                            }
            //                        }
            //                    }
            //                }
            //
            //                HStack(alignment: .top) {
            //
            //                    if viewModel.mode == "view" {
            //                        Text("Duration")
            //                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
            //                        Spacer()
            //                        Text(activity.formattedDuration + " Hours")
            //                            .foregroundColor(.secondary)
            //                            .multilineTextAlignment(.trailing)
            //                    } else {
            //                        Text("Duration")
            //                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
            //                        Spacer()
            //                        Picker("Hours", selection: $viewModel.hours) {
            //                            ForEach(0..<25) {
            //                                Text("\($0)")
            //                            }
            //                        }
            //                        .pickerStyle(.wheel)
            //                        .frame(maxHeight: 150)
            //                        .clipped()
            //
            //                        VStack {
            //                            Spacer()
            //                            Text("Hrs")
            //                            Spacer()
            //                        }
            //                        .frame(maxHeight: 150)
            //                        .clipped()
            //
            //                        Picker("Minutes", selection: $viewModel.minutes) {
            //                            ForEach(0..<60) {
            //                                Text("\($0)")
            //                            }
            //                        }
            //                        .pickerStyle(.wheel)
            //                        .frame(maxHeight: 150)
            //                        .clipped()
            //
            //                        VStack {
            //                            Spacer()
            //                            Text("Min")
            //                            Spacer()
            //                        }
            //                        .frame(maxHeight: 150)
            //                        .clipped()
            //                    }
            //                }
            //
            //                HStack(alignment: .top) {
            //                    Text("Date")
            //                        .frame(width: geometry.size.width * 0.3, alignment: .leading)
            //                    Spacer()
            //                    Text(activity.wrappedStartDate.formatted(.dateTime.day().month().year()))
            //                        .foregroundColor(.secondary)
            //                        .multilineTextAlignment(.trailing)
            //                }
            //            }
            .padding(.top)
            .navigationBarTitle("Activity Detail", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup {
                    if viewModel.mode == "view" {
                        Button("Edit") {
                            viewModel.prepareEdit(for: activity)
                        }
                        .padding()
                    } else {
                        Button("Save") {
                            viewModel.edit(for: activity)
                            try? moc.save()
                            refreshId = UUID()
                        }
                        .disabled(viewModel.updatedDuration.isEmpty)
                        .padding()
                    }
                }
            }
            .onAppear {
                let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId).png")
                viewModel.activityImage = Utils.loadImage(from: imagePath)
            }
            .sheet(isPresented: $viewModel.showEditGoals) {
                VStack {
                    NavigationStack {
                        GoalSelectionView(selectedGoals: $viewModel.updatedGoals)
                            .navigationTitle("Edit Goals")
                            .toolbar {
                                ToolbarItemGroup {
                                    Button("Back") {
                                        viewModel.showEditGoals.toggle()
                                    }
                                }
                            }
                    }
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
