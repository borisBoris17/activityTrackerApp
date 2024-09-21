//
//  Utils.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 10/03/2024.
//

import Foundation
import SwiftUI

enum Utils {
    
    static func loadImage(from url: URL) -> Image? {
        do {
            let foundActivityImageData = try Data(contentsOf: url)
            let uiImage = UIImage(data: foundActivityImageData)
            return Image(uiImage: uiImage ?? UIImage(systemName: "photo")!)
        } catch {
//            print("Error reading file: \(error)")
            return nil
        }
    }
    
    static func removeImage(from url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error deleting file: \(error)")
        }
    }
}
