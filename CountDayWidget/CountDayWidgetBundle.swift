//
//  CountDayWidgetBundle.swift
//  CountDayWidget
//
//  Created by Server DOĞAN on 22.11.2024.
//

import WidgetKit
import SwiftUI

@main
struct CountDayWidgetBundle: WidgetBundle {
    var body: some Widget {
        CountDayWidget()
        CountDayWidgetControl()
        CountDayWidgetLiveActivity()
    }
}
