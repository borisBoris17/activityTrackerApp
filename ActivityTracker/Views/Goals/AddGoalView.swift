//
//  AddGoalView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI

struct AddGoalView: View {
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    @State private var viewModel = ViewModel()
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var refreshData: RefreshData
    
    var body: some View {
        
        VStack {
            NavigationStack {
                Form {
                    Section {
                        TextField("Name", text: $viewModel.newGoalName)
                    } header: {
                        Text("Goal Name")
                    } footer: {
                        if viewModel.goalNameBlankOnSave {
                            Text("Name is required.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(viewModel.goalNameBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    Section("Goal Description") {
                        TextField("Description", text: $viewModel.newGoalDesc)
                    }
                    
                    Section {
                        Picker("Who's Goal?", selection: $viewModel.newGoalPerson) {
                            Text("None").tag(-1)
                            ForEach(0 ..< people.count, id: \.self) { i in
                                Text("\(people[i].wrappedName)")
                            }
                        }
                    } header: {
                        
                    } footer: {
                        if viewModel.personBlankOnSave {
                            Text("Must select at least one Goal.")
                                .foregroundColor(Color.red)
                        }
                    }
                    .listRowBackground(viewModel.personBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    Section("Duration") {
                        DatePicker(selection: $viewModel.newGoalStartDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Start Date")
                        }
                        
                        DatePicker(selection: $viewModel.newGoalEndDate, in: Date.now..., displayedComponents: .date) {
                            Text("End Date")
                        }
                    }
                    
                    Section {
                        TextField("Target", text: $viewModel.newGoalTarget)
                            .keyboardType(.decimalPad)
                    } header: {
                        Text("Target")
                    } footer: {
                        VStack(alignment: .leading) {
                            if viewModel.goalTargetBlankOnSave {
                                Text("Target is required and must be a positive number.")
                                    .foregroundColor(Color.red)
                            }
                            Text("Enter number of Hours that completes the Goal.")
                        }
                    }
                    .listRowBackground(viewModel.goalTargetBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                    
                    Section {
                        TextField("Time already achieved (in hours)", text: $viewModel.newGoalProgreess)
                            .keyboardType(.decimalPad)
                    } header: {
                        Text("Progress")
                    } footer: {
                        Text("Enter any hours already completed for this Goal.")
                    }
                }
                .navigationBarItems(leading: Button("Cancel") { dismiss() })
                .navigationBarTitle("Add Goal", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup {
                        
                        Button("Save") {
                            if viewModel.validateSave() {
                                viewModel.create(newGoal: Goal(context: moc), for: people[viewModel.newGoalPerson])
                                
                                try? moc.save()
                                refreshData.goalRefreshId = UUID()
                                refreshData.activityRefreshId = UUID()
                                
                                dismiss()
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalView()
    }
}
