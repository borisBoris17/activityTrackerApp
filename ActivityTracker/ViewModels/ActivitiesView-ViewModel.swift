//
//  ActivitiesView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 10/03/2024.
//

import Foundation
import SwiftUI

extension ActivitiesView {
    
    @Observable
    class ViewModel {
        var showNewActivitySheet = false
        var activityStatus = ActivityStatus.ready
        
        var activityFilter: ActivityFilter = .selectedDay
        var showAll = false
        
        var showCompleteActivityScreen = false
        
        var startTime =  Date()
        var pausedSeconds = 0
        var totalSeconds = 0
        
        var name = ""
        var desc = ""
        var selectedGoals: [Goal] = []
        var day = Date.now
        
        var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        var startingSunday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -(Calendar.current.component(.weekday, from: Date.now) - 1), to: Date.now)!)
        
        var selectedDay = Calendar.current.startOfDay(for: Date.now)
        
        func timerString() -> String {
            let seconds = String(format: "%02d", totalSeconds % minuteLength)
            let minutes = String(format: "%02d", (totalSeconds / minuteLength) % hourLength)
            let hours = String(format: "%02d", totalSeconds / (minuteLength * hourLength))
            return hours == "00" ? "\(minutes):\(seconds)" : "\(hours):\(minutes):\(seconds)"
        }
        
        func pauseTimer() {
            pausedSeconds = totalSeconds
            timer.upstream.connect().cancel()
            activityStatus = .paused
        }
        
        func resumeTimer() {
            startTime = Date()
            activityStatus = .started
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
        
        func handleRecieveTimer() {
            //totalSeconds = pausedSeconds + Int(Date().timeIntervalSince(startTime)) -- add one second to the timer (normal case)
            totalSeconds = pausedSeconds + (Int(Date().timeIntervalSince(startTime)) * 900) // add 15 minutes at a time
        }
        
        func updateTimer() {
            if activityStatus == .started {
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            } else {
                timer.upstream.connect().cancel()
            }
        }
        
        @MainActor func create(newActivity activity: Activity, with activityImage: Image?) {
            activity.id = UUID()
            activity.name = name
            activity.desc = desc
            activity.goals = NSSet(array: selectedGoals)
            activity.duration = Int16(totalSeconds)
            activity.startDate = Calendar.current.startOfDay(for: Date.now)
                                
            if activityImage != nil {
                let renderer = ImageRenderer(content: activityImage)
                if let uiImage = renderer.uiImage {
                    if let data = uiImage.pngData() {
                        let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.id!).png")
                        try? data.write(to: filename)
                    }
                }
            }
            
            // Update all of the Goals. Add the duration to the progress
            for goal in selectedGoals {
                goal.progress = goal.progress + Double(totalSeconds)
            }
                                
            pausedSeconds = 0
            totalSeconds = 0
            activityStatus = .ready
            name = ""
            desc = ""
            timer.upstream.connect().cancel()
        }
    }
}
