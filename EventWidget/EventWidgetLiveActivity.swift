//
//  EventWidgetLiveActivity.swift
//  EventWidget
//
//  Created by Server DOĞAN on 23.11.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct EventWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct EventWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EventWidgetAttributes.self) { context in
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

extension EventWidgetAttributes {
    fileprivate static var preview: EventWidgetAttributes {
        EventWidgetAttributes(name: "World")
    }
}

extension EventWidgetAttributes.ContentState {
    fileprivate static var smiley: EventWidgetAttributes.ContentState {
        EventWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: EventWidgetAttributes.ContentState {
         EventWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: EventWidgetAttributes.preview) {
   EventWidgetLiveActivity()
} contentStates: {
    EventWidgetAttributes.ContentState.smiley
    EventWidgetAttributes.ContentState.starEyes
}
