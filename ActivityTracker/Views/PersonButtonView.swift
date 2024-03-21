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
    @State private var isLoading = true
    var imageHasChanged: Bool
    
    var body: some View {
        Group {
            if isLoading {
                VStack {
                    LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                }
                .opacity(0.5)
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
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
                                .frame(width: selectedPerson == person ? imageSize * 1.25 : imageSize, height: selectedPerson == person ? imageSize * 1.25 : imageSize)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        } else {
                            personImage?
                                .resizable()
                                .frame(width: selectedPerson == person ? imageSize * 1.25 : imageSize, height: selectedPerson == person ? imageSize * 1.25 : imageSize)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Text(person.wrappedName)
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
                        .frame(width: selectedPerson == person ? imageSize * 1.25 : imageSize, height: selectedPerson == person ? imageSize * 1.25 : imageSize)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            }
        }
        .onAppear {
            Task {
                let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/personImages").appendingPathComponent("\(person.wrappedId).png")
                personImage = Utils.loadImage(from: imagePath)
                isLoading = false
            }
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
