//
//  OnboardingViewModel.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import SwiftUI
import Observation

// MARK: - Onboarding ViewModel

/// Manages state and navigation logic for the onboarding flow using iOS 17 @Observable
/// 
/// Updated to follow 2024 SwiftUI MVVM best practices with proper dependency injection
/// and separated concerns for navigation and user persistence
@Observable
final class OnboardingViewModel {
    
    // MARK: - State Properties
    
    /// Current step index in the onboarding sequence (0-based)
    var currentStepIndex: Int = 0
    

    
    /// Controls presentation of sign-in sheet
    var showSignInSheet = false
    
    /// Controls presentation of account creation sheet  
    var showCreateAccountSheet = false
    
    // MARK: - Private Properties
    
    /// Static array of onboarding steps
    private let steps = OnboardingStep.steps
    
    /// Dependencies for navigation and user persistence
    private let navigationManager: NavigationManager
    private let userRepository: UserRepository
    
    // MARK: - Computed Properties
    
    /// Returns the current onboarding step based on the current index.
    /// 
    /// - Returns: Current `OnboardingStep` or first step if index is invalid
    var currentStep: OnboardingStep {
        guard currentStepIndex >= 0 && currentStepIndex < steps.count else {
            return steps[0]
        }
        return steps[currentStepIndex]
    }
    
    /// Determines if the user is viewing the final onboarding step.
    /// 
    /// - Returns: `true` if on the last step, `false` otherwise
    var isLastStep: Bool {
        return currentStepIndex >= steps.count - 1
    }
    
    /// Determines if the user is viewing the initial onboarding step.
    /// 
    /// - Returns: `true` if on the first step, `false` otherwise
    var isFirstStep: Bool {
        return currentStepIndex <= 0
    }
    
    /// Total count of onboarding steps available.
    /// 
    /// - Returns: Integer count of all onboarding steps
    var totalSteps: Int {
        return steps.count
    }
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with required dependencies.
    /// 
    /// - Parameters:
    ///   - navigationManager: Navigation state manager
    ///   - userRepository: User data repository
    init(
        navigationManager: NavigationManager,
        userRepository: UserRepository
    ) {
        self.navigationManager = navigationManager
        self.userRepository = userRepository
    }
    
    // MARK: - Navigation Methods
    
    /// Advances to the next step in the onboarding sequence.
    /// 
    /// If already on the last step, completes the onboarding process
    /// and transitions to the main application flow.
    @MainActor
    func nextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentStepIndex < steps.count - 1 {
                currentStepIndex += 1
            } else {
                // Complete onboarding and move to main
                Task {
                    await completeOnboarding()
                }
            }
        }
    }
    
    /// Returns to the previous step in the onboarding sequence.
    /// 
    /// Does nothing if already on the first step.
    @MainActor
    func previousStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentStepIndex > 0 {
                currentStepIndex -= 1
            }
        }
    }
    
    /// Navigates directly to a specific onboarding step.
    /// 
    /// - Parameter index: Target step index (must be valid)
    /// - Note: Validates index bounds before navigation
    @MainActor
    func goToStep(_ index: Int) {
        guard index >= 0 && index < steps.count else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStepIndex = index
        }
    }
    
    /// Finalizes the onboarding experience and transitions to main app.
    @MainActor
    func completeOnboarding() async {
        await userRepository.setOnboardingCompleted(true)
        navigationManager.navigateToMain()
    }
    

    
    // MARK: - Sheet Management
    
    /// Shows the sign-in sheet
    @MainActor
    func showSignIn() {
        showSignInSheet = true
    }
    
    /// Shows the create account sheet
    @MainActor
    func showCreateAccount() {
        showCreateAccountSheet = true
    }
    
    /// Dismisses all authentication sheets
    @MainActor
    func dismissAuthenticationSheets() {
        showSignInSheet = false
        showCreateAccountSheet = false
    }
    
    // MARK: - UI State Helpers
    
    /// Determines the appropriate footer style for the current step
    var footerStyle: OnboardingFooterStyle {
        if currentStepIndex == 0 {
            return .continue
        } else if isLastStep {
            return .authentication
        } else {
            return .navigation
        }
    }
    
    /// Creates demo user and completes onboarding
    @MainActor
    func createDemoUserAndComplete() async {
        let demoUser = User(
            email: AppConstants.Demo.demoEmail,
            name: AppConstants.Demo.demoUserName,
            isEmailVerified: true
        )
        
        do {
            try await userRepository.saveUser(demoUser)
            await userRepository.setOnboardingCompleted(true)
            navigationManager.navigateToMain()
        } catch {
            // Handle error silently for demo mode
        }
    }

}

// MARK: - Supporting Types

/// Defines the footer style for different onboarding steps
enum OnboardingFooterStyle {
    case `continue`      // First step with continue button
    case navigation      // Middle steps with prev/next buttons
    case authentication  // Last step with authentication options
}