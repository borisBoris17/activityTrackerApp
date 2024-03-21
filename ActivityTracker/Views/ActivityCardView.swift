//
//  ActivityCardView.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 13/03/2024.
//

import SwiftUI

struct ActivityCardView: View {
    var activity: Activity
    var geometry: GeometryProxy
    @State private var activityImage: Image?
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                if isLoading {
                    LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .opacity(0.5)
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                } else {
                    activityImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                }
                VStack(alignment: .leading) {
                    Text("\(activity.wrappedName)")
                        .font(.title3)
                        .lineLimit(1)
                        .foregroundStyle(.brandText)
                    
                    Text("\(activity.wrappedDesc)")
                        .lineLimit(1)
                        .foregroundStyle(.brandMediumLight)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Goals")
                        .foregroundStyle(.brandText)
                        .font(.footnote)
                        
                    
                    ForEach(activity.goalArray) { goal in
                        if !goal.peopleArray.isEmpty {
                            Text("\(goal.peopleArray[0].wrappedName) - \(goal.wrappedName)")
                                .lineLimit(1)
                                .foregroundColor(.brandMediumLight)
                        } else {
                            Text("\("unknwn person") - \(goal.wrappedName)")
                                .foregroundColor(.brandMediumLight)
                        }
                    }
                }
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                Text("\(activity.formattedDuration) hrs")
                    .foregroundStyle(.brandText)
                    .font(.title)
            }
        }
        .padding()
        .frame(maxWidth: nil, minHeight: 165)
        .background(.brandBackground, in: RoundedRectangle(cornerRadius: 16))
        .onAppear {
            Task {
                let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId).png")
                activityImage = Utils.loadImage(from: imagePath)
                isLoading = false
            }
        }
    }
}

//#Preview {
//    ActivityCardView()
//}
