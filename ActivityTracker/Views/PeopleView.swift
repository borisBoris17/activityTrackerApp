//
//  PeopleView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/02/2024.
//

import SwiftUI

struct PeopleView: View {
    
    @State public var selectedPerson: Person? = nil
    @FetchRequest(sortDescriptors: []) var people: FetchedResults<Person>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    Section(header: Text("People")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(people) { person in
                                    Button {
                                        print("person", person)
                                        selectedPerson = person
                                    } label: {
                                        VStack {
                                            Image(systemName: "person.badge.plus")
                                                .resizable()
                                                .frame(width: 104, height: 72)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .strokeBorder(.white, lineWidth: 1)
                                                )
                                            
                                            VStack(alignment: .leading) {
                                                Text(person.wrappedName)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    if selectedPerson != nil {
                        Section(header: Text("Details")) {
                            List {
                                HStack(alignment: .top) {
                                    //                        if mode == "view" {
                                    //                            Text("Name")
                                    //                                .frame(width: geometry.size.width * 0.3, alignment: .leading)
                                    //                            Spacer()
                                    //                            Text(activity.wrappedName)
                                    //                                .foregroundColor(.secondary)
                                    //                                .multilineTextAlignment(.trailing)
                                    //                        } else {
                                    //                            Text("Name")
                                    //                                .frame(width: geometry.size.width * 0.3, alignment: .leading)
                                    //                            Spacer()
                                    //                            TextField("Name", text: $updatedName)
                                    //                                .multilineTextAlignment(.trailing)
                                    //                                .background(Color.secondary)
                                    //                        }
                                    
                                    Text("Name")
                                    //                                    .frame(width: geometry.size.width * 0.3, alignment: .leading)
                                    Spacer()
                                    Text(selectedPerson?.wrappedName ?? "unknown")
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                        }
                        
                        Section(header: Text("Goals")) {
                            List {
                                ForEach(selectedPerson!.goalsArray) { goal in
                                    HStack(alignment: .top) {
                                        //                        if mode == "view" {
                                        //                            Text("Name")
                                        //                                .frame(width: geometry.size.width * 0.3, alignment: .leading)
                                        //                            Spacer()
                                        //                            Text(activity.wrappedName)
                                        //                                .foregroundColor(.secondary)
                                        //                                .multilineTextAlignment(.trailing)
                                        //                        } else {
                                        //                            Text("Name")
                                        //                                .frame(width: geometry.size.width * 0.3, alignment: .leading)
                                        //                            Spacer()
                                        //                            TextField("Name", text: $updatedName)
                                        //                                .multilineTextAlignment(.trailing)
                                        //                                .background(Color.secondary)
                                        //                        }
                                        
                                        Text("\(goal.wrappedName)")
                                        //                                    .frame(width: geometry.size.width * 0.3, alignment: .leading)
                                        Spacer()
                                        Text(goal.wrappedDesc)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.trailing)
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    PeopleView()
}
