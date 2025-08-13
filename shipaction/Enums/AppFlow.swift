//
//  AppFlow.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import Foundation

// MARK: - App Flow State

/// Represents the current navigation state of the application.
/// 
/// Used to control the primary navigation flow between different
/// sections of the application.
public enum AppFlow: Equatable {
    /// User is viewing the onboarding experience
    case onboarding
    /// User is in the main application interface
    case main
}