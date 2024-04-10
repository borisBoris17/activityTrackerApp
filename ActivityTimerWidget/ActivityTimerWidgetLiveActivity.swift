//
//  ActivityTimerWidgetLiveActivity.swift
//  ActivityTimerWidget
//
//  Created by tucker bichsel on 07/04/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ActivityTimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ActivityTimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ActivityTimerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ActivityTimerWidgetAttributes {
    fileprivate static var preview: ActivityTimerWidgetAttributes {
        ActivityTimerWidgetAttributes(name: "World")
    }
}

extension ActivityTimerWidgetAttributes.ContentState {
    fileprivate static var smiley: ActivityTimerWidgetAttributes.ContentState {
        ActivityTimerWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ActivityTimerWidgetAttributes.ContentState {
         ActivityTimerWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ActivityTimerWidgetAttributes.preview) {
   ActivityTimerWidgetLiveActivity()
} contentStates: {
    ActivityTimerWidgetAttributes.ContentState.smiley
    ActivityTimerWidgetAttributes.ContentState.starEyes
}
