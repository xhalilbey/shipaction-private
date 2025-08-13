//
//  HapticFeedbackManager.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import UIKit

// MARK: - Haptic Feedback Manager

/// Centralized haptic feedback management for better performance and consistency
/// 
/// Provides pre-configured haptic feedback generators to avoid repeated initialization
/// and improve performance across the app. Follows singleton pattern for efficient resource usage.
final class HapticFeedbackManager {
    
    // MARK: - Singleton
    
    static let shared = HapticFeedbackManager()
    
    // MARK: - Feedback Generators
    
    /// Light impact feedback generator - cached for performance
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    /// Medium impact feedback generator - cached for performance  
    private let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    /// Heavy impact feedback generator - cached for performance
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    /// Selection feedback generator - cached for performance
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    /// Notification feedback generator - cached for performance
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Initialization
    
    private init() {
        // Pre-prepare generators for optimal performance
        prepareGenerators()
    }
    
    // MARK: - Public Interface
    
    /// Plays light impact haptic feedback
    /// 
    /// Use for subtle interactions like tab selection or button taps
    func playLightImpact() {
        lightImpactGenerator.impactOccurred()
    }
    
    /// Plays medium impact haptic feedback
    /// 
    /// Use for moderate interactions like confirmations or selections
    func playMediumImpact() {
        mediumImpactGenerator.impactOccurred()
    }
    
    /// Plays heavy impact haptic feedback
    /// 
    /// Use for strong interactions like errors or important actions
    func playHeavyImpact() {
        heavyImpactGenerator.impactOccurred()
    }
    
    /// Plays selection haptic feedback
    /// 
    /// Use for picker selections or value changes
    func playSelection() {
        selectionGenerator.selectionChanged()
    }
    
    /// Plays success notification haptic feedback
    /// 
    /// Use for successful operations or completed actions
    func playSuccess() {
        notificationGenerator.notificationOccurred(.success)
    }
    
    /// Plays warning notification haptic feedback
    /// 
    /// Use for warning states or cautionary actions
    func playWarning() {
        notificationGenerator.notificationOccurred(.warning)
    }
    
    /// Plays error notification haptic feedback
    /// 
    /// Use for errors or failed operations
    func playError() {
        notificationGenerator.notificationOccurred(.error)
    }
    
    // MARK: - Private Methods
    
    /// Pre-prepares all haptic generators for optimal performance
    /// 
    /// This reduces latency when haptic feedback is triggered
    private func prepareGenerators() {
        lightImpactGenerator.prepare()
        mediumImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        selectionGenerator.prepare()
        notificationGenerator.prepare()
    }
}