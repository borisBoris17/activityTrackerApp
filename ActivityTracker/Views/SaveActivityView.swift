//
//  SaveActivityView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 23/01/2024.
//

import SwiftUI

struct SaveActivityView: View {
    @Binding var name: String
    @Binding var desc: String
    var saveActivity: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                Form {
                    HStack(alignment: .top) {
                        Text("Name")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextField("Name", text: $name)
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                    HStack(alignment: .top) {
                        Text("Description")
                            .frame(width: geometry.size.width * 0.3, alignment: .leading)
                        Spacer()
                        TextEditor( text: $desc)
                            .frame(minHeight: 150,
                                   maxHeight: .infinity,
                                   alignment: .center )
                            .multilineTextAlignment(.trailing)
                            .background(Color.secondary)
                    }
                }
            }
            .navigationTitle("Save Activity")
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        saveActivity()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                    .padding()
                }
            }
        }
    }
}

//#Preview {
//    SaveActivityView()
//}
