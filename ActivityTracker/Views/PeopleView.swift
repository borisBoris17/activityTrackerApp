//
//  PeopleView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/02/2024.
//

import SwiftUI

struct PeopleView: View {
    
    @State private var isLoading = true
    @State public var numPeople = 0
    @State public var selectedPerson: Person? = nil
    @State var showAddPerson = false
    @State private var imageHasChanged = false
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                
                ZStack {
                    VStack {
                        HorizontalPeopleView(people: people, imageSize: geometry.size.width * 0.18, selectedPerson: $selectedPerson, imageHasChanged: imageHasChanged)
                                                    
                        if let selectedPerson = selectedPerson {
                            PersonDetailView(person: selectedPerson, geometry: geometry, imageHasChanged: $imageHasChanged)
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
                                showAddPerson = true
                            } label : {
                                Label("Add New Person", systemImage: "plus")
                            }
                            .buttonStyle(BlueButton())
                        }
                    }
                }
                
            }
            .navigationTitle("People")
            .sheet(isPresented: $showAddPerson) {
                AddPersonView()
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    PeopleView()
}
