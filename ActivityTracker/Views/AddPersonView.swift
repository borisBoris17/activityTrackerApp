//
//  AddPersonView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/08/2023.
//

import SwiftUI

struct AddPersonView: View {
    @State private var newName = ""
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section {
                        TextField("Name", text: $newName)
                    }
                    
                    Button {
                        print("Add a Person")
                        let newPerson = Person(context: moc)
                        newPerson.id = UUID()
                        newPerson.name = newName
                        
                        try? moc.save()
                        dismiss()
                    } label: {
                        HStack {
                            Text("Save Person")
                            Image(systemName: "doc.badge.plus")
                        }
                    }
                }
                .navigationTitle("Add Person")
            }
        }
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
