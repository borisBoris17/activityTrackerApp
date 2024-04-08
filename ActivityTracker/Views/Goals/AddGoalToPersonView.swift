//
//  AddGoalToPersonView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 16/02/2024.
//

import SwiftUI

struct AddGoalToPersonView: View {
    var person: Person
    
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
                .navigationBarTitle("Add Goal to \(person.wrappedName)", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup {
                        
                        Button("Save") {
                            viewModel.create(newGoal: Goal(context: moc), for: person);
                            
                            try? moc.save()
                            refreshData.goalRefreshId = UUID()
                            refreshData.activityRefreshId = UUID()
                            
                            dismiss()
                        }
                        .disabled(viewModel.newGoalName.isEmpty || viewModel.newGoalTarget.isEmpty)
                        .padding()
                    }
                }
            }
        }
    }
}

//#Preview {
//    AddGoalToPersonView()
//}
