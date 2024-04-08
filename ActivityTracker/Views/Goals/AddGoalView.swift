//
//  AddGoalView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 25/08/2023.
//

import SwiftUI
import MultiPicker

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
                    Section("Goal Name") {
                        TextField("Name", text: $viewModel.newGoalName)
                    }
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
                    }
                    
                    Section("Duration") {
                        DatePicker(selection: $viewModel.newGoalStartDate, in: ...Date.now, displayedComponents: .date) {
                            Text("Start Date")
                        }
                        
                        DatePicker(selection: $viewModel.newGoalEndDate, in: Date.now..., displayedComponents: .date) {
                            Text("End Date")
                        }
                    }
                    
                    Section("Target") {
                        TextField("Target (in hours)", text: $viewModel.newGoalTarget)
                            .keyboardType(.decimalPad)
                    }
                    
                    Section("Progress") {
                        TextField("Time already achieved (in hours)", text: $viewModel.newGoalProgreess)
                            .keyboardType(.decimalPad)
                    }
                }
                .navigationBarItems(leading: Button("Cancel") { dismiss() })
                .navigationBarTitle("Add Goal", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup {
                        
                        Button("Save") {
                            viewModel.create(newGoal: Goal(context: moc), for: people[viewModel.newGoalPerson])
                            
                            try? moc.save()
                            refreshData.goalRefreshId = UUID()
                            refreshData.activityRefreshId = UUID()
                            
                            dismiss()
                        }
                        .disabled(viewModel.newGoalName.isEmpty || viewModel.newGoalPerson == -1 || viewModel.newGoalTarget.isEmpty)
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
