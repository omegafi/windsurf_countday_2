//
//  CountDayWidgetLiveActivity.swift
//  CountDayWidget
//
//  Created by Server DOĞAN on 22.11.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CountDayWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CountDayWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountDayWidgetAttributes.self) { context in
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

extension CountDayWidgetAttributes {
    fileprivate static var preview: CountDayWidgetAttributes {
        CountDayWidgetAttributes(name: "World")
    }
}

extension CountDayWidgetAttributes.ContentState {
    fileprivate static var smiley: CountDayWidgetAttributes.ContentState {
        CountDayWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CountDayWidgetAttributes.ContentState {
         CountDayWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CountDayWidgetAttributes.preview) {
   CountDayWidgetLiveActivity()
} contentStates: {
    CountDayWidgetAttributes.ContentState.smiley
    CountDayWidgetAttributes.ContentState.starEyes
}
