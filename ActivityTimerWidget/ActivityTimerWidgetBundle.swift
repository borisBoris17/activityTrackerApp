//
//  ActivityTimerWidgetBundle.swift
//  ActivityTimerWidget
//
//  Created by tucker bichsel on 07/04/2024.
//

import WidgetKit
import SwiftUI

@main
struct ActivityTimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        ActivityTimerWidget()
        ActivityTimerWidgetLiveActivity()
    }
}
