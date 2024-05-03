//
//  ActivitiesView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 10/03/2024.
//

import ActivityKit
import Foundation
import SwiftUI
import CoreData

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
        var manualHours = 0
        var manualMinutes = 0
        var day = Date.now
        
        var currentActivty: Activity? = nil
        
        var activityWidget: ActivityKit.Activity<ActivityTimerAttributes>? = nil
        
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
        
        func handleRecieveTimer(_ moc: NSManagedObjectContext) {
            if activityWidget == nil {
                startActivityWidget()
            }
            totalSeconds = pausedSeconds + Int(Date().timeIntervalSince(startTime))
            if totalSeconds % 60 == 0 {                
                updateDuration(activity: currentActivty!, isManual: false)
//                if activityWidget != nil {
//                    updateActivityWidget()
//                }
                try? moc.save()
            }
        }
        
        func updateActivityWidget() {
            guard let activityWidget = activityWidget else {
                return
            }
            
            let contentState = ActivityTimerAttributes.ContentState(hours: numHours(), minutes: numMinutes())
            Task {
                await activityWidget.update(
                    ActivityContent<ActivityTimerAttributes.ContentState>(
                        state: contentState,
                        staleDate: Date.now + 15,
                        relevanceScore: 50
                    ),
                    alertConfiguration: nil
                )
            }
        }
        
        func numHours() -> Int {
            return totalSeconds / 3600
        }
        
        func numMinutes() -> Int {
            return (totalSeconds - (numHours() * 3600)) / 60
        }
        
        func stopActivityWidget() {
            let finalContent = ActivityTimerAttributes.ContentState(
                hours: 0,
                minutes: 0
            )
            
            Task {
                await activityWidget?.end(ActivityContent(state: finalContent, staleDate: nil), dismissalPolicy: .immediate)
                activityWidget = nil
            }
        }
        
        func startActivityWidget() {
            let attributes = ActivityTimerAttributes(activityName: name, activityDescription: desc)
            let initialState = ActivityTimerAttributes.ContentState(hours: 0, minutes: 0)
            
            do {
                let activity = try ActivityKit.Activity.request(
                    attributes: attributes,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: .token
                )
                
                activityWidget = activity
            } catch (let error) {
                print("Error Starting the Activity Widget.", error)
            }
        }
        
        func updateTimer() {
            if activityStatus == .started {
                timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            } else {
                timer.upstream.connect().cancel()
            }
        }
        
        @MainActor func create(activity: Activity) {
            activity.id = UUID()
            activity.name = name
            activity.desc = desc
            activity.goals = NSSet(array: selectedGoals)
            activity.startDate = Calendar.current.startOfDay(for: Date.now)
            currentActivty = activity
        }
        
        func updateDuration(activity: Activity, isManual: Bool) {
            var previousActivityDuration = activity.duration
            var durationInSeconds = totalSeconds
            if isManual {
                let newSecondsFromHour = manualHours * minuteLength * hourLength
                let newSecondsFromMinutes = manualMinutes * minuteLength
                let newSeconds = newSecondsFromHour + newSecondsFromMinutes
                durationInSeconds = newSeconds
            }
            activity.duration = Int32(durationInSeconds)
            
            // Update all of the Goals. Add the duration to the progress
            for goal in selectedGoals {
                goal.progress = goal.progress - Double(previousActivityDuration) + Double(durationInSeconds)
            }
        }
        
        
        @MainActor func complete(with activityImage: Image?, isManual: Bool) {
            guard let activity = currentActivty else { print("Error completeing the activity."); return }
            updateDuration(activity: activity, isManual: isManual)
            activity.name = name
            activity.desc = desc
            
            if activityImage != nil {
                let renderer = ImageRenderer(content: activityImage)
                if let uiImage = renderer.uiImage {
                    if let data = uiImage.pngData() {
                        let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.id!).png")
                        try? data.write(to: filename)
                    }
                    let size = CGSize(width: 200, height: 200)
                    if let thumbImage = uiImage.preparingThumbnail(of: size) {
                        if let data = thumbImage.jpegData(compressionQuality: 1.0) {
                            let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId)Thumb.png")
                            try? data.write(to: filename)
                        }
                    }
                }
            }
            
            pausedSeconds = 0
            totalSeconds = 0
            activityStatus = .ready
            name = ""
            desc = ""
            manualHours = 0
            manualMinutes = 0
            currentActivty = nil
            timer.upstream.connect().cancel()
            stopActivityWidget()
//            activityWidget = nil 
        }
    }
}
