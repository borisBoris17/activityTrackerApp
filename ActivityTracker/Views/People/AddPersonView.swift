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
    
    @EnvironmentObject var refreshData: RefreshData
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NavigationStack {
                    Form {
                        Section {
                            TextField("Name", text: $viewModel.newName)
                            
                        } header: {
                            
                        } footer: {
                            if viewModel.nameBlankOnSave {
                                Text("Name is required.")
                                    .foregroundColor(Color.red)
                            }
                        }
                        .listRowBackground(viewModel.nameBlankOnSave ? Color.red.opacity(0.25) : Color(UIColor.secondarySystemGroupedBackground))
                        
                        Section {
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
                                if viewModel.validateSave() {
                                    viewModel.savePerson(newPerson: Person(context: moc))
                                    try? moc.save()
                                    refreshData.goalRefreshId = UUID()
                                    refreshData.activityRefreshId = UUID()
                                    dismiss()
                                }
                            }
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
