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
        NavigationView {
            GeometryReader { geometry in
//                VStack {
//                    LoaderView(tintColor: .blue, scaleSize: 13.0)
//                        .hidden(!isLoading)
//                }
                
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

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}

#Preview {
    PeopleView()
}
