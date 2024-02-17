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
    @State private var personImage: Image?
    
    var body: some View {
        Button {
            selectedPerson = person
        } label: {
            ZStack() {
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
                
                VStack() {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(person.wrappedName)
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                    }
                }
                .padding(.bottom)
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
