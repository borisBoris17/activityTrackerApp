//
//  PeopleView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/02/2024.
//

import SwiftUI

struct PeopleView: View {
    
    @Binding var path: NavigationPath
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                
                ZStack {
                    ScrollView {
                        HorizontalPeopleView(people: people, imageSize: geometry.size.width * 0.33, selectedPerson: $viewModel.selectedPerson, imageHasChanged: viewModel.imageHasChanged)
                                                    
                        if let selectedPerson = viewModel.selectedPerson {
                            PersonDetailView(person: selectedPerson, geometry: geometry, imageHasChanged: $viewModel.imageHasChanged, path: $path, clearPerson: viewModel.clearPerson)
                        } else {
                            Spacer()
                        }
                    }
                    .padding([.top, .leading])
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button() {
                                viewModel.showAddPerson = true
                            } label : {
                                Label("Add New Person", systemImage: "plus")
                            }
                            .buttonStyle(BlueButton())
                        }
                    }
                }
            }
            .background(.neutralLight)
            .navigationBarTitle("People", displayMode: .inline)
            .sheet(isPresented: $viewModel.showAddPerson) {
                AddPersonView()
                    .presentationDetents([.medium])
            }
            .navigationDestination(for: Goal.self) { goal in
                VStack {
                    GoalDetailView(goal: goal, path: $path)
                }
            }
            .navigationDestination(for: Activity.self) { activity in
                ActivityView(activity: activity, refreshId: $viewModel.refreshId, path: $path)
            }
            .onAppear {
                if people.count > 0 && viewModel.selectedPerson == nil {
                    viewModel.selectedPerson = people[0]
                }
            }
        }
    }
}

//#Preview {
//    PeopleView()
//}
