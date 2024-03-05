//
//  PersonButtonView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 14/02/2024.
//

import SwiftUI

struct PersonButtonView: View {
    var person: Person
    @Binding var selectedPerson: Person?
    @State private var personImage: Image? = Image(systemName: "questionmark")
    var imageHasChanged: Bool
    
    var body: some View {
        Button {
            if selectedPerson == nil || !selectedPerson!.isEqual(person){
                selectedPerson = person
            } else {
                selectedPerson = nil
            }
        } label: {
            VStack() {
                if personImage != nil {
                    personImage!
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .scaledToFill()
                        .padding(5)
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .padding()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(.white, lineWidth: 1)
                        )
                        .padding(5)
                }
                
                Text(person.wrappedName)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: 100)
            }
        }
        .onAppear {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
            do {
                let foundActivityImageData = try Data(contentsOf: imagePath)
                let uiImage = UIImage(data: foundActivityImageData)
                personImage = Image(uiImage: uiImage ?? UIImage(systemName: "photo")!)
            } catch {
                print("Error reading file: \(error)")
            }
        }
    }
}

//#Preview {
//    PersonButtonView()
//}
