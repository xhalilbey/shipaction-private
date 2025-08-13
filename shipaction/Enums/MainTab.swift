//
//  MainTab.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - Main Tab Enum

/// Represents the available tabs in the main application interface.
/// 
/// Each tab corresponds to a major functional area of the application
/// with associated display names and SF Symbol icons.
enum MainTab: String, CaseIterable {
    /// Home/dashboard with AI agents
    case home = "Home"
    /// Search functionality
    case search = "Search"
    /// AI chat assistant
    case ai = "AI"
    /// Saved items library
    case library = "Library"
    /// User profile
    case profile = "Profile"
    
    // MARK: - Computed Properties
    
    /// Display text for the tab.
    /// 
    /// - Returns: Text string to display instead of icons
    var displayText: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .ai:
            return "AI"
        case .library:
            return "Library"
        case .profile:
            return "Profile"
        }
    }
    
    /// SF Symbol icon name for the tab.
    /// 
    /// - Returns: System icon name string for use with `Image(systemName:)`
    var iconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .search:
            return "magnifyingglass"
        case .ai:
            return "sparkles"
        case .library:
            return "bookmark.fill"
        case .profile:
            return "person.fill"
        }
    }
}
