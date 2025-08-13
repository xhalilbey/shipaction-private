//
//  AppConstants.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import SwiftUI

// MARK: - App Constants

/// Central location for application-wide constants and configuration values.
/// 
/// Organizes constants by functional area to maintain consistency
/// and make updates easier across the entire application.
struct AppConstants {
    
    // MARK: - UserDefaults Keys
    
    /// Keys used for storing data in UserDefaults
    struct UserDefaultsKeys {
        /// Key for storing onboarding completion status
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        
        /// Key for storing user data
        static let userData = "userData"
        
        /// Key for storing selected tab
        static let selectedTab = "selectedTab"
        
        /// Key for storing user preferences
        static let userPreferences = "userPreferences"
    }
    
    // MARK: - Validation Constants
    
    /// Constants related to input validation
    struct Validation {
        /// Minimum password length requirement
        static let minimumPasswordLength = 6
        
        /// Maximum password length requirement
        static let maximumPasswordLength = 128
        
        /// Minimum full name length requirement
        static let minimumNameLength = 2
        
        /// Maximum full name length requirement
        static let maximumNameLength = 50
        
        /// Email validation regex pattern
        static let emailRegexPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        /// Maximum search query length
        static let maximumSearchLength = 100
    }
    
    // MARK: - Animation Constants
    
    /// Constants for consistent animations across the app
    struct Animation {
        /// Standard transition duration for view changes
        static let transitionDuration = 0.5
        
        /// Fast transition for quick UI updates
        static let fastTransition = 0.2
        
        /// Slow transition for complex animations
        static let slowTransition = 0.8
        
        /// Form field animation duration
        static let fieldAnimationDuration = 0.2
        
        /// Button press animation duration
        static let buttonPressDuration = 0.1
        
        /// Tab bar selection animation duration
        static let tabSelectionDuration = 0.3
        
        /// Modal presentation duration
        static let modalDuration = 0.4
        
        /// Spring animation response
        static let springResponse = 0.5
        
        /// Spring animation damping
        static let springDamping = 0.7
    }
    
    // MARK: - UI Constants
    
    /// Constants for consistent UI measurements
    struct UI {
        /// Standard button height
        static let buttonHeight: CGFloat = 54
        
        /// Compact button height for secondary actions
        static let compactButtonHeight: CGFloat = 44
        
        /// Large button height for primary actions
        static let largeButtonHeight: CGFloat = 56
        
        /// Standard corner radius for buttons
        static let buttonCornerRadius: CGFloat = 14
        
        /// Small corner radius for subtle elements
        static let smallCornerRadius: CGFloat = 8
        
        /// Large corner radius for prominent elements
        static let largeCornerRadius: CGFloat = 20
        
        /// Standard padding for main content
        static let standardPadding: CGFloat = 24
        
        /// Horizontal padding for main content
        static let horizontalPadding: CGFloat = 24
        
        /// Vertical padding for sections
        static let verticalPadding: CGFloat = 16
        
        /// Compact padding for tight spaces
        static let compactPadding: CGFloat = 12
        
        /// Large padding for spacious layouts
        static let largePadding: CGFloat = 32
        
        /// Standard spacing between form elements
        static let formSpacing: CGFloat = 20
        
        /// Compact spacing for dense layouts
        static let compactSpacing: CGFloat = 12
        
        /// Large spacing for breathing room
        static let largeSpacing: CGFloat = 32
        
        /// Icon size for tab bar
        static let tabIconSize: CGFloat = 24
        
        /// Icon size for buttons
        static let buttonIconSize: CGFloat = 20
        
        /// Icon size for headers
        static let headerIconSize: CGFloat = 32
        
        /// Standard divider height
        static let dividerHeight: CGFloat = 0.5
        
        /// Tab bar height
        static let tabBarHeight: CGFloat = 80
        
        /// Navigation bar height
        static let navigationBarHeight: CGFloat = 56
    }
    
    // MARK: - Colors
    
    /// Consistent color palette for the application
    struct Colors {
        /// Primary brand color - Dark Teal (#014140)
        static let primary = Color(hex: "014140")
        
        /// Secondary brand color
        static let secondary = Color(.systemGray)
        
        /// Accent color for highlights
        static let accent = Color.blue
        
        /// Success color for positive actions
        static let success = Color(hex: "28A745")
        
        /// Warning color for caution
        static let warning = Color.orange
        
        /// Error color for problems
        static let error = Color.red
        
        /// Background color for main content (light)
        static let background = Color(hex: "FDFDF7")

        /// Background color for dark mode (requested tone)
        static let darkBackground = Color(hex: "091717")

        /// Surface color: near-background but slightly darker for cards/chips
        static let surface = Color(hex: "F1F3EE")

        /// Strong surface color: a bit more contrast than `surface`
        static let surfaceStrong = Color(hex: "E8ECE6")
        
        /// Secondary background for cards/sections
        static let secondaryBackground = Color(.secondarySystemBackground)
        
        /// Grouped background for lists
        static let groupedBackground = Color(.systemGroupedBackground)
        
        /// Border color for dividers
        static let border = Color(.separator)
        
        /// Subtle border color
        static let subtleBorder = Color(.systemGray5)
        
        /// Text color for primary content
        static let primaryText = Color(hex: "2E2E2E")
        
        /// Text color for secondary content
        static let secondaryText = Color(hex: "2E2E2E").opacity(0.8)
        
        /// Text color for tertiary content
        static let tertiaryText = Color(.tertiaryLabel)
        
        /// Overlay color for modals
        static let overlay = Color.black.opacity(0.4)
        
        /// Glass effect background
        static let glass = Color.white.opacity(0.1)

        /// Dark mode elevated surface for chips/search backgrounds
        /// Requested exact tone: #091717
        static let darkSurfaceElevated = Color(hex: "091717")

        /// Dark mode token background for badges/labels (matches Save button background tone)
        /// Slightly reduced contrast per design feedback
        static let darkTokenBackground = Color.white.opacity(0.05)
    }
    
    // MARK: - Typography
    
    /// Consistent typography scale
    struct Typography {
        /// Large title font size
        static let largeTitle: CGFloat = 34
        
        /// Title 1 font size
        static let title1: CGFloat = 28
        
        /// Title 2 font size
        static let title2: CGFloat = 22
        
        /// Title 3 font size
        static let title3: CGFloat = 20
        
        /// Headline font size
        static let headline: CGFloat = 17
        
        /// Body font size
        static let body: CGFloat = 17
        
        /// Callout font size
        static let callout: CGFloat = 16
        
        /// Subheadline font size
        static let subheadline: CGFloat = 15
        
        /// Footnote font size
        static let footnote: CGFloat = 13
        
        /// Caption 1 font size
        static let caption1: CGFloat = 12
        
        /// Caption 2 font size
        static let caption2: CGFloat = 11
        
        /// Line spacing for body text
        static let bodyLineSpacing: CGFloat = 2
        
        /// Line spacing for headers
        static let headerLineSpacing: CGFloat = 4
    }
    
    // MARK: - Demo Constants
    
    /// Demo data for testing and previews
    struct Demo {
        /// Demo user email
        static let demoEmail = "demo@payaction.com"
        
        /// Demo user name
        static let demoUserName = "Demo User"
    }

}