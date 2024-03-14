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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                activityImage?
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15)
                VStack(alignment: .leading) {
                    Text("\(activity.wrappedName)")
                        .font(.title3)
                        .lineLimit(1)
                        .foregroundStyle(.brandColorDark)
                    
                    Text("\(activity.wrappedDesc)")
                        .lineLimit(1)
                        .foregroundStyle(.brandMediumLight)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
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
            }
        }
        .foregroundStyle(.brandColorDark)
        .padding()
        .frame(maxWidth: nil, minHeight: 165)
        .background(.brandColorLight, in: RoundedRectangle(cornerRadius: 16))
        .onAppear {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId).png")
            activityImage = Utils.loadImage(from: imagePath)
        }
    }
}

//#Preview {
//    ActivityCardView()
//}
