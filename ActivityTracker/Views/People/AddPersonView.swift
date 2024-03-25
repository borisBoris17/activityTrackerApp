//
//  AddPersonView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 31/08/2023.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddPersonView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NavigationStack {
                    Form {
                        Section {
                            TextField("Name", text: $viewModel.newName)
                            ImagePickerView(photoItem: $viewModel.personPhotoItem, selectedImageData: $viewModel.personImageData, imageSize: geometry.size.width * 0.15)
                                .onChange(of: viewModel.personImageData) {
                                    viewModel.updatePersonImage()
                                }
                        }
                    }
                    .navigationBarTitle("Add Person", displayMode: .inline)
                    .toolbar {
                        ToolbarItem {
                            Button("Save") {
                                viewModel.savePerson(newPerson: Person(context: moc))
                                try? moc.save()
                                dismiss()
                            }
                            .disabled(viewModel.newName.isEmpty)
                            .padding()
                        }
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
