//
//  ActivityTimerAttributes.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 07/04/2024.
//

import ActivityKit
import SwiftUI

struct ActivityTimerAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var currentTimePassed: String
    }
    
    var activityName: String
    var activityDescription: String
}
