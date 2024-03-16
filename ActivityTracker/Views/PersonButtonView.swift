//
//  PersonButtonView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 14/02/2024.
//

import SwiftUI

struct PersonButtonView: View {
    var person: Person
    var imageSize: CGFloat
    @Binding var selectedPerson: Person?
    @State private var personImage: Image?
    var imageHasChanged: Bool
    
    var body: some View {
        Button {
            withAnimation {
                if selectedPerson == nil || !selectedPerson!.isEqual(person){
                    selectedPerson = person
                } else {
                    selectedPerson = nil
                }
            }
        } label: {
            ZStack() {
                if personImage == nil {
                    Image(systemName: "person")
                        .resizable()
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(.white, lineWidth: 1)
                        )
                } else {
                    personImage?
                        .resizable()
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text(person.wrappedName)
                        //                            .font(.title2)
                            .foregroundStyle(.brandText)
                            .fontWeight(.bold)
                            .padding(.top)
                            .padding(.trailing, 7)
                            .padding(.bottom, 3)
                            .lineLimit(1)
                    }
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.clear, .neutral]), startPoint: .top, endPoint: .bottom)
                    )
                }
            }
            .frame(width: selectedPerson == person ? imageSize * 1.25 : imageSize, height: selectedPerson == person ? imageSize * 1.25 : imageSize)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .onAppear {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
            personImage = Utils.loadImage(from: imagePath)
        }
        .onChange(of: imageHasChanged) {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
            personImage = Utils.loadImage(from: imagePath)
        }
    }
}

//#Preview {
//    PersonButtonView()
//}
