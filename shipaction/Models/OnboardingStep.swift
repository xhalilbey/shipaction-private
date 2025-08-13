//
//  OnboardingStep.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation
import SwiftUI

// MARK: - OnboardingStep Model

/// Represents a single step in the application onboarding sequence.
/// 
/// Each step contains the visual and textual content needed to guide
/// users through the app introduction process. Conforms to `Identifiable`
/// for SwiftUI list operations and `Equatable` for comparison.
struct OnboardingStep: Identifiable, Equatable {
    /// Unique identifier for the onboarding step
    let id = UUID()
    
    /// Main heading text for the step
    let title: String
    
    /// Detailed description explaining the step's purpose
    let description: String
    
    /// SF Symbol name for the step's icon
    let iconName: String
    
    /// Theme color associated with the step
    let color: Color
    
    // MARK: - Static Data
    
    /// Predefined sequence of onboarding steps for the application.
    /// 
    /// These steps guide users through PayAction's key features and
    /// value propositions before account creation or sign-in.
    /// 
    /// - Note: Modify this array to customize the onboarding experience
    static let steps: [OnboardingStep] = [
        OnboardingStep(
            title: "Welcome to PayAction AI",
            description: "The next generation platform for accessing powerful AI models with a revolutionary pay-as-you-go pricing model.",
            iconName: "circle.hexagongrid.fill",
            color: AppConstants.Colors.primary
        ),
        OnboardingStep(
            title: "Pay Only for What You Use",
            description: "We've collected the best AI models in one place. Pay for AI like your utility bill - use only what you need, when you need it.",
            iconName: "waveform.path.ecg.rectangle.fill",
            color: AppConstants.Colors.primary
        ),
        OnboardingStep(
            title: "Customizable AI Agents",
            description: "Create personalized AI agents that work across all your applications. Complete your AI tasks without the limitations of other platforms.",
            iconName: "rectangle.3.group.bubble.left.fill",
            color: AppConstants.Colors.primary
        ),
        OnboardingStep(
            title: "Create Your Billing Account",
            description: "Set up your account and payment details to start accessing our powerful AI tools with transparent pay-as-you-go pricing.",
            iconName: "wallet.pass.fill",
            color: AppConstants.Colors.primary
        ),
        OnboardingStep(
            title: "Let's Begin",
            description: "You're all set to experience the future of AI. Start using our platform today and pay only for what you need.",
            iconName: "checkmark.circle.fill",
            color: AppConstants.Colors.primary
        )
    ]
} 