//
//  ActivityTimerWidget.swift
//  ActivityTimerWidget
//
//  Created by tucker bichsel on 07/04/2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct ActivityTimerWidgetView: View {
    let context: ActivityViewContext<ActivityTimerAttributes>
    
    var body: some View {
        HStack() {
            
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(context.attributes.activityName)
                    .font(.headline)
                
                Text(context.attributes.activityDescription)
            }
            
            Spacer()
            
//          layout for when there is a time on the live activity
//          Spacer()
//            HStack(alignment: .lastTextBaseline) {
//                if context.state.hours > 0 {
//                    Text("\(context.state.hours)")
//                        .contentTransition(.identity)
//                        .font(.system(size: 45))
//                        .fontWeight(.bold)
//                    
//                    VStack {
//                        Spacer()
//                        
//                        Text("hr")
//                            .contentTransition(.identity)
//                            .fontWeight(.bold)
//                    }
//                    
//                }
//                Text("\(context.state.minutes)")
//                    .contentTransition(.identity)
//                    .font(.system(size: 45))
//                    .fontWeight(.bold)
//                
//                
//                Text("min")
//                    .contentTransition(.identity)
//                    .fontWeight(.bold)
//            }
            
        }
    }
}

struct ActivityTimerWidget: Widget {
    let kind: String = "ActivityTimerWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ActivityTimerAttributes.self) { context in
            ActivityTimerWidgetView(context: context)
                .padding()
                .activityBackgroundTint(.black.opacity(0.5))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
                DynamicIslandExpandedRegion(.trailing) {
                    
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading) {
                        Text(context.attributes.activityName)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading) {
                        
                        Text(context.attributes.activityDescription)
                    }
                }
            } compactLeading: {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .clipShape(Circle())
            } compactTrailing: {
                Text(context.attributes.activityName.count < 6 ? context.attributes.activityName : String(context.attributes.activityName.prefix(5)) + "...")
            } minimal: {
                
            }
        }
    }
}

#Preview(as: .systemSmall) {
    ActivityTimerWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
