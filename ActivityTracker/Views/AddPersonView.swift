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
                }
                .navigationBarTitle("Add Person", displayMode: .inline)
                .toolbar {
                    ToolbarItem {
                        Button("Save") {
                            let newPerson = Person(context: moc)
                            newPerson.id = UUID()
                            newPerson.name = newName
                            
                            try? moc.save()
                            dismiss()
                        }
                        .disabled(newName.isEmpty)
                        .padding()
                    }
                }
            }
        }
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView()
    }
}
