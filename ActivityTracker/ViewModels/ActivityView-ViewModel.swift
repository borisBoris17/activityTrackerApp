//
//  ActivityView-ViewModel.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 10/03/2024.
//

import Foundation
import _PhotosUI_SwiftUI
import SwiftUI
import CoreData

extension ActivityView {
    
    @Observable
    class ViewModel {
        var mode = "view"
        var updatedDuration = ""
        var updatedName = ""
        var updatedDescription = ""
        var hours = 0
        var minutes = 0
        
        var activityPhotoItem: PhotosPickerItem?
        var activityImageData: Data?
        var activityImage: Image?
        
        var showEditGoals = false
        var showEditActivity = false
        var updatedGoals = Set<Goal>()
        
        func removeActivityImage(on activity: Activity) {
            let imagePath = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId).png")
            Utils.removeImage(from: imagePath)
            activityImage = nil
        }
        
        func prepareEdit(for activity: Activity) {
            updatedDuration = activity.formattedDuration
            updatedName = activity.wrappedName
            updatedDescription = activity.wrappedDesc
            let durationSegments = activity.formattedDuration.components(separatedBy: ".")
            hours = Int(durationSegments[0]) ?? 0
            let decimalMinutes = Double(durationSegments[1]) ?? 0
            let calculatedMinutes = Int(ceil((decimalMinutes / 100) * Double(minuteLength)))
            if calculatedMinutes < hourLength {
                minutes = calculatedMinutes
            } else {
                minutes = 0
            }
            
            updatedGoals = Set<Goal>(activity.goalArray)
            showEditActivity.toggle()
            
        }
        
        @MainActor func edit(for activity: Activity) {
            var removedGoals = Set<Goal>()
            var addedGoals = Set<Goal>()
            var editedGoal = Set<Goal>()
            let newSecondsFromHour = hours * minuteLength * hourLength
            let newSecondsFromMinutes = minutes * hourLength
            let newSeconds = Double(newSecondsFromHour + newSecondsFromMinutes)
            let oldSeconds = Double(activity.duration)
            
            // Find the Goals that were removed
            for existingGoal in activity.goalArray {
                if !updatedGoals.contains(existingGoal) {
                    removedGoals.insert(existingGoal)
                }
            }
            
            // Find all the Goals that were added.
            for updatedGoal in updatedGoals {
                if !activity.goalArray.contains(updatedGoal) {
                    addedGoals.insert(updatedGoal)
                } else {
                    editedGoal.insert(updatedGoal)
                }
            }
            
            // take away the progress that was made toward the removed goals (using the previously saved time)
            for removedGoal in removedGoals {
                removedGoal.progress = removedGoal.progress - oldSeconds
            }
            
            // Add the new time to the added goals progress
            for addedGoal in addedGoals {
                addedGoal.progress = addedGoal.progress + newSeconds.rounded(.up)
            }
            
            // modify the goals that were neither removed or added
            for goal in editedGoal {
                goal.progress = (goal.progress - oldSeconds) + newSeconds.rounded(.up)
            }
            
            activity.duration = Int32(newSeconds.rounded(.up))
            activity.name = updatedName
            activity.desc = updatedDescription
            activity.goals = updatedGoals as NSSet
            let renderer = ImageRenderer(content: activityImage)
            if let uiImage = renderer.uiImage {
                if let data = uiImage.pngData() {
                    let filename = FileManager.getDocumentsDirectory().appendingPathExtension("/activityImages").appendingPathComponent("\(activity.wrappedId).png")
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
            
            updatedGoals = Set<Goal>()
            withAnimation {
                mode = "view"
            }
        }
    }
}
