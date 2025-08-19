//
//  NoInternetView.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI

// MARK: - No Internet View

/// Modern no internet connection view with retry functionality
struct NoInternetView: View {
    
    // MARK: - Properties
    
    /// Network manager for connectivity monitoring
    @State private var networkManager = NetworkManager.shared
    
    /// Loading state for retry operation
    @State private var isRetrying = false
    
    /// Animation state for floating elements
    @State private var isAnimating = false
    
    /// Optional retry callback to let parent refresh state
    let onRetry: (() -> Void)?
    
    /// Color scheme environment for dynamic background
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dynamic app background consistent with app (non-onboarding)
                AppConstants.Colors.dynamicBackground(colorScheme)
                    .ignoresSafeArea()
                
                // Main content
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Animated WiFi Icon
                    ZStack {
                        // Background circle
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppConstants.Colors.primary.opacity(0.1),
                                        AppConstants.Colors.primary.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                        
                        // WiFi slash icon
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundStyle(AppConstants.Colors.primary)
                            .symbolEffect(.pulse.byLayer, options: .repeating)
                    }
                    
                    // Text content
                    VStack(spacing: 16) {
                        Text("No Internet Connection")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Please check your internet connection\nand try again")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 32)
                    

                    
                    Spacer()
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        // Retry button - uses unified design
                        UnifiedButton(
                            title: "Try Again",
                            style: .primary,
                            isLoading: isRetrying,
                            isEnabled: !isRetrying
                        ) {
                            Task {
                                await retryConnection()
                                // Notify parent to re-evaluate startup/navigation
                                onRetry?()
                            }
                        }
                        .frame(maxWidth: 320)
                        
                        // Tips section
                        VStack(spacing: 12) {
                            Text("Connection Tips:")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.primary)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                TipRow(icon: "wifi", text: "Check your WiFi connection")
                                TipRow(icon: "antenna.radiowaves.left.and.right", text: "Try switching to mobile data")
                                TipRow(icon: "airplane", text: "Make sure Airplane Mode is off")
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.systemGray4).opacity(0.5), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 32))
                }
                
                // Floating particles effect
                ForEach(0..<5, id: \.self) { index in
                    FloatingParticle(delay: Double(index) * 0.4)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    // MARK: - Actions
    
    /// Retries internet connection
    @MainActor
    private func retryConnection() async {
        isRetrying = true
        HapticFeedbackManager.shared.playLightImpact()
        
        // Wait a moment for visual feedback
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Test actual internet access
        let hasInternet = await networkManager.testInternetAccess()
        
        if hasInternet {
            HapticFeedbackManager.shared.playSuccess()
            LoggingService.shared.logInfo("Internet connection restored via retry")
        } else {
            HapticFeedbackManager.shared.playError()
            LoggingService.shared.logInfo("Internet connection still unavailable")
        }
        
        isRetrying = false
    }
}

// MARK: - Tip Row Component

/// Individual tip row component
struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(AppConstants.Colors.primary)
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.secondary)
            
            Spacer()
        }
    }
}

// MARK: - Floating Particle Component

/// Animated floating particle for visual effect
struct FloatingParticle: View {
    let delay: Double
    @State private var isVisible = false
    @State private var yOffset: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        AppConstants.Colors.primary.opacity(0.3),
                        AppConstants.Colors.primary.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 6, height: 6)
            .opacity(isVisible ? 0.6 : 0)
            .offset(y: yOffset)
            .position(
                x: CGFloat.random(in: 50...350),
                y: CGFloat.random(in: 100...600)
            )
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 3.0)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    isVisible = true
                    yOffset = -50
                }
            }
    }
}

// MARK: - Preview

#Preview {
    NoInternetView(onRetry: nil)
}