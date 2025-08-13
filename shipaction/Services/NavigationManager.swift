//
//  NavigationManager.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import SwiftUI
import Observation

// MARK: - Navigation Manager

/// Centralized navigation state management using iOS 17 @Observable
/// 
/// Replaces the scattered navigation logic in AppStateManager
/// Following 2024 SwiftUI best practices with @Observable macro
@Observable
final class NavigationManager {
    
    // MARK: - Published State
    
    /// Current application flow state
    var currentFlow: AppFlow = .onboarding
    
    /// Loading state for navigation transitions
    var isNavigating = false
    
    // MARK: - Navigation Methods
    
    /// Navigates to main application flow
    /// 
    /// Called after successful authentication or onboarding completion
    @MainActor
    func navigateToMain() {
        withAnimation(.easeInOut(duration: AppConstants.Animation.transitionDuration)) {
            currentFlow = .main
        }
    }
    
    /// Navigates to onboarding flow
    /// 
    /// Called during logout or app reset
    @MainActor
    func navigateToOnboarding() {
        withAnimation(.easeInOut(duration: AppConstants.Animation.transitionDuration)) {
            currentFlow = .onboarding
        }
    }
    
    /// Sets navigation loading state
    /// 
    /// - Parameter isLoading: Loading state to set
    @MainActor
    func setNavigationLoading(_ isLoading: Bool) {
        isNavigating = isLoading
    }
}