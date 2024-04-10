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
        HStack {
            
            Image("icon")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .clipShape(Circle())
            
            Text(context.attributes.activityName)
                .font(.headline)
            
            Spacer()
            
            Text(context.state.currentTimePassed)
                .contentTransition(.identity)
                .font(.system(size: 45))
                .fontWeight(.bold)
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
                }
                DynamicIslandExpandedRegion(.trailing) {
                    
                        Image("icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                }
                DynamicIslandExpandedRegion(.center) {
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading) {
                        Text(context.attributes.activityName)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(context.attributes.activityDescription)
                    }
                }
            } compactLeading: {
                
            } compactTrailing: {
                
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
