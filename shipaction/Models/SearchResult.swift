//
//  SearchResult.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - Search Result Model

/// Model representing a search result item
struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: String
}