//
//  SavedItem.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - Saved Item Model

/// Model representing a saved/bookmarked item
struct SavedItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let type: String
    let imageURL: String?
    let savedAt: Date
    
    // Convenience init for existing code
    init(title: String, description: String, imageURL: String? = nil) {
        self.title = title
        self.subtitle = description
        self.type = "agent"
        self.imageURL = imageURL
        self.savedAt = Date()
    }
    
    // Full init
    init(title: String, subtitle: String?, type: String, imageURL: String? = nil, savedAt: Date = Date()) {
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.imageURL = imageURL
        self.savedAt = savedAt
    }
}