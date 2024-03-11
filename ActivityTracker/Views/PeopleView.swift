//
//  PeopleView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/02/2024.
//

import SwiftUI

struct PeopleView: View {
    
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                
                ZStack {
                    VStack {
                        HorizontalPeopleView(people: people, imageSize: geometry.size.width * 0.18, selectedPerson: $viewModel.selectedPerson, imageHasChanged: viewModel.imageHasChanged)
                                                    
                        if let selectedPerson = viewModel.selectedPerson {
                            PersonDetailView(person: selectedPerson, geometry: geometry, imageHasChanged: $viewModel.imageHasChanged)
                        } else {
                            Spacer()
                        }
                    }
                    .padding(.top)
                    
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
            .navigationTitle("People")
            .sheet(isPresented: $viewModel.showAddPerson) {
                AddPersonView()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    PeopleView()
}
