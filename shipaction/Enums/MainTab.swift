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
    /// Footpath navigation
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
            return "Footpath"
        case .ai:
            return "Started"
        case .library:
            return "Base"
        case .profile:
            return "Settings"
        }
    }
    
    /// SF Symbol icon name for the tab.
    /// 
    /// - Returns: System icon name string for use with `Image(systemName:)`
    var iconName: String {
        switch self {
        case .home:
            return "flame.fill"
        case .search:
            return "chevron.up.forward.2"
        case .ai:
            return "square.3.layers.3d"
        case .library:
            return "square.grid.2x2"
        case .profile:
            return "gearshape.fill"
        }
    }
}
