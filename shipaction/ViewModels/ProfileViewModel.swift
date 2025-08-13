//
//  ProfileViewModel.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import Foundation
import Observation

// MARK: - Profile ViewModel

/// ViewModel for user profile management
@Observable
final class ProfileViewModel {
    
    // MARK: - State
    
    var user: User?
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Dependencies
    
    private let authenticationService: AuthenticationService
    private let userRepository: UserRepository
    private let navigationManager: NavigationManager
    
    // MARK: - Initialization
    
    init(
        authenticationService: AuthenticationService,
        userRepository: UserRepository,
        navigationManager: NavigationManager
    ) {
        self.authenticationService = authenticationService
        self.userRepository = userRepository
        self.navigationManager = navigationManager
    }
    
    // MARK: - Actions
    
    @MainActor
    func loadUserProfile() async {
        isLoading = true
        errorMessage = nil
        
        // Simulate loading user profile - replace with actual implementation
        user = User(
            id: "demo_user",
            email: "demo@example.com", 
            name: "Demo User",
            profileImageURL: nil,
            isEmailVerified: true
        )
        
        isLoading = false
    }
    
    @MainActor
    func signOut() async {
        isLoading = true
        
        do {
            try await authenticationService.signOut()
            navigationManager.navigateToOnboarding()
        } catch {
            errorMessage = "Sign out failed"
            LoggingService.shared.logError(error, context: "ProfileViewModel.signOut")
        }
        
        isLoading = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}