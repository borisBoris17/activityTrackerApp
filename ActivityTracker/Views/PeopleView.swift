//
//  PeopleView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/02/2024.
//

import SwiftUI

struct PeopleView: View {
    
    @State public var selectedPerson: Person? = nil
    @State var showAddPerson = false
    @State private var imageHasChanged = false
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        HorizontalPeopleView(people: people, selectedPerson: $selectedPerson, imageHasChanged: imageHasChanged)
                            .padding(.bottom)
                        
                        if let selectedPerson = selectedPerson {
                            PersonDetailView(person: selectedPerson, geometry: geometry, imageHasChanged: $imageHasChanged)
                        } else {
                            Spacer()
                        }
                    }
                    
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
            }
        }
    }
}

#Preview {
    PeopleView()
}
