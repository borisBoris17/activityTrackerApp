//
//  FileManager+DocDirectory.swift
//  ActivityTracker
//
//  Created by tucker bichsel on 12/02/2024.
//

import Foundation

public extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
