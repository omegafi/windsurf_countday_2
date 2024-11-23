//
//  EventWidgetBundle.swift
//  EventWidget
//
//  Created by Server DOĞAN on 23.11.2024.
//

import WidgetKit
import SwiftUI

@main
struct EventWidgetBundle: WidgetBundle {
    var body: some Widget {
        EventWidget()
        EventWidgetControl()
        EventWidgetLiveActivity()
    }
}
