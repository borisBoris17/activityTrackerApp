//
//  HorizontalPeopleView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 14/02/2024.
//

import SwiftUI

struct HorizontalPeopleView: View {
    var people: FetchedResults<Person>
    //    var height: Int
    @Binding var selectedPerson: Person?
    @State var showAddPerson = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack() {
                Button {
                    showAddPerson = true
                } label: {
                    ZStack() {
                        HStack {
                            Spacer()
                            Image(systemName: "person.badge.plus")
                                .resizable()
                                .padding()
                                .clipShape(Circle())
                            //                                .overlay(
                            //                                    Circle()
                            //                                        .strokeBorder(.white, lineWidth: 1)
                            //                                )
                                .scaledToFit()
                                .frame(width: 100)
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("Add Person")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Spacer()
                            }
                        }
                    }
                }
                ForEach(people) { person in
                    PersonButtonView(person: person, selectedPerson: $selectedPerson)
                }
            }
            .frame(height: 100)
        }
        .sheet(isPresented: $showAddPerson) {
            AddPersonView()
        }
    }
}

//#Preview {
//    HorizontalPeopleView()
//}
