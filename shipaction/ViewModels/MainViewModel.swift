//
//  MainViewModel.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import SwiftUI
import Observation

// MARK: - Main ViewModel

/// ViewModel managing the main application interface state and tab navigation.
/// 
/// Centralizes tab selection logic, provides child ViewModels for each tab,
/// and handles main app navigation flows following MVVM principles.
@Observable
final class MainViewModel {
    
    // MARK: - Published State
    
    /// Currently selected tab in the main interface
    var selectedTab: MainTab = .home
    
    /// Loading state for tab transitions
    var isNavigating = false
    

    
    // MARK: - Dependencies
    
    private let authenticationService: AuthenticationService
    private let userRepository: UserRepository
    private let navigationManager: NavigationManager
    private let loggingService: LoggingServiceProtocol
    
    // MARK: - Child ViewModels
    
    /// ViewModel for the home/dashboard tab
    private(set) var homeViewModel: HomeViewModel
    
    /// ViewModel for the search functionality
    private(set) var searchViewModel: SearchViewModel
    
    /// ViewModel for AI chat functionality
    private(set) var aiChatViewModel: AIChatViewModel
    
    /// ViewModel for saved items/library
    private(set) var libraryViewModel: LibraryViewModel
    
    /// ViewModel for user profile
    private(set) var profileViewModel: ProfileViewModel
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with required dependencies and child ViewModels.
    /// 
    /// - Parameters:
    ///   - authenticationService: Service for authentication operations
    ///   - userRepository: Repository for user data operations
    ///   - navigationManager: Manager for app-level navigation
    ///   - homeViewModel: ViewModel for home functionality
    ///   - searchViewModel: ViewModel for search functionality
    ///   - aiChatViewModel: ViewModel for AI chat functionality
    ///   - libraryViewModel: ViewModel for library functionality
    ///   - profileViewModel: ViewModel for profile functionality
    init(
        authenticationService: AuthenticationService,
        userRepository: UserRepository,
        navigationManager: NavigationManager,
        loggingService: LoggingServiceProtocol,
        homeViewModel: HomeViewModel,
        searchViewModel: SearchViewModel,
        aiChatViewModel: AIChatViewModel,
        libraryViewModel: LibraryViewModel,
        profileViewModel: ProfileViewModel
    ) {
        self.authenticationService = authenticationService
        self.userRepository = userRepository
        self.navigationManager = navigationManager
        self.loggingService = loggingService
        self.homeViewModel = homeViewModel
        self.searchViewModel = searchViewModel
        self.aiChatViewModel = aiChatViewModel
        self.libraryViewModel = libraryViewModel
        self.profileViewModel = profileViewModel
    }
    

    
    // MARK: - Tab Management
    
    /// Switches to the specified tab with animation.
    /// 
    /// - Parameter tab: The target tab to navigate to
    @MainActor
    func selectTab(_ tab: MainTab) {
        withAnimation(.easeInOut(duration: AppConstants.Animation.tabSelectionDuration)) {
            selectedTab = tab
        }
        
        // Optimized haptic feedback with static instance
        HapticFeedbackManager.shared.playLightImpact()
    }
    
    /// Determines if the specified tab is currently selected.
    /// 
    /// - Parameter tab: The tab to check
    /// - Returns: True if the tab is selected, false otherwise
    func isTabSelected(_ tab: MainTab) -> Bool {
        return selectedTab == tab
    }
    
    // MARK: - Navigation Actions
    
    /// Signs out the current user and returns to onboarding.
    @MainActor
    func signOut() async throws {
        isNavigating = true
        
        do {
            try await authenticationService.signOut()
            try await userRepository.clearUser()
            navigationManager.navigateToOnboarding()
            loggingService.logInfo("User successfully signed out")
        } catch let error as AuthenticationError {
            loggingService.logError(error, context: "User sign out")
            isNavigating = false
            throw error
        } catch {
            loggingService.logError(error, context: "User sign out")
            isNavigating = false
            throw AuthenticationError.unknown(error)
        }
        
        isNavigating = false
    }
    
    // MARK: - Data Loading
    
    /// Loads initial data for all tab ViewModels concurrently
    /// 
    /// Uses TaskGroup for efficient parallel loading of tab data
    @MainActor
    func loadInitialData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.homeViewModel.loadAgents()
            }
            group.addTask {
                await self.libraryViewModel.loadSavedItems()
            }
            group.addTask {
                await self.profileViewModel.loadUserProfile()
            }
        }
    }
}