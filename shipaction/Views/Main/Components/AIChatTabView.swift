//
//  AIChatTabView.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - AI Chat Tab View

/// AI Chat functionality tab view - Coming Soon
struct AIChatTabView: View {
    
    // MARK: - Properties
    
    @Bindable var viewModel: AIChatViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Animation State
    @State private var headerVisible = false
    @State private var firstCardVisible = false
    @State private var secondCardVisible = false
    @State private var thirdCardVisible = false
    @State private var shine1: CGFloat = -0.2
    @State private var shine2: CGFloat = -0.2
    @State private var shine3: CGFloat = -0.2
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                    .opacity(headerVisible ? 1 : 0)
                    .offset(y: headerVisible ? 0 : -8)
                    .animation(.easeInOut(duration: 0.35), value: headerVisible)
                    .padding(.top, 20)
                
                Spacer()
                
                // Three premium cards centered on screen
                VStack(spacing: 18) {
                    hireAgentHeroCard
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .opacity(firstCardVisible ? 1 : 0)
                        .offset(y: firstCardVisible ? 0 : 20)
                        .scaleEffect(firstCardVisible ? 1 : 0.95)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0.5),
                            value: firstCardVisible
                        )
                    
                    createAgentHeroCard
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .opacity(secondCardVisible ? 1 : 0)
                        .offset(y: secondCardVisible ? 0 : 25)
                        .scaleEffect(secondCardVisible ? 1 : 0.95)
                        .animation(
                            .spring(response: 0.65, dampingFraction: 0.8, blendDuration: 0.5),
                            value: secondCardVisible
                        )
                        
                    selectAgentHeroCard
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .opacity(thirdCardVisible ? 1 : 0)
                        .offset(y: thirdCardVisible ? 0 : 30)
                        .scaleEffect(thirdCardVisible ? 1 : 0.95)
                        .animation(
                            .spring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.5),
                            value: thirdCardVisible
                        )
                }
                .padding(.horizontal, 20)
                
                Spacer() // Center the cards
            }
            .background(backgroundColor)
            .tint(AppConstants.Colors.primary)
            .onAppear {
                // Enhanced staggered entrance with premium timing
                withAnimation(.easeOut(duration: 0.4)) {
                headerVisible = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    firstCardVisible = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.spring(response: 0.65, dampingFraction: 0.8)) {
                    secondCardVisible = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring(response: 0.7, dampingFraction: 0.8)) {
                        thirdCardVisible = true
                    }
                }
                
                // Premium shine animations with staggered delays
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(
                        .linear(duration: 2.5)
                        .repeatForever(autoreverses: false)
                    ) { 
                        shine1 = 1.3 
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(
                        .linear(duration: 3.0)
                    .repeatForever(autoreverses: false)
                    ) { 
                        shine2 = 1.3 
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(
                        .linear(duration: 2.8)
                    .repeatForever(autoreverses: false)
                    ) { 
                        shine3 = 1.3 
                    }
                }
            }
        }
    }
}

// MARK: - Message Bubble

struct MessageBubble: View {
    let message: ChatMessage
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 60)
                messageContent
                    .background(AppConstants.Colors.primary)
                    .foregroundStyle(.white)
            } else {
                messageContent
                    .background(nonUserBubbleBackground)
                    .foregroundStyle(.primary)
                Spacer(minLength: 60)
            }
        }
    }
    
    private var messageContent: some View {
        Text(message.content)
            .font(.body)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

// MARK: - Typing Indicator

struct TypingIndicator: View {
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color(.tertiaryLabel))
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            Spacer(minLength: 60)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Tokens
private extension AIChatTabView {
    var backgroundColor: Color { 
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
    var headerForegroundColor: Color { AppConstants.Colors.primary }
    
    // Clean header with logo and brand
    var header: some View {
        // Logo and brand section
        HStack(spacing: 12) {
            Spacer(minLength: 0)
            
            Image(AppConstants.Colors.dynamicLogo(colorScheme))
                .resizable()
                .aspectRatio(contentMode: .fit)
            .frame(width: 28, height: 28)
            .accessibilityHidden(true)
            
            Text("Nexor")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                .accessibilityIdentifier("brand_title")
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
    }
    
    // Three premium cards with continuous modern pattern
    var hireAgentHeroCard: some View {
        AILargeHeroCard(
            iconName: "briefcase.fill",
            title: "Hire an Agent",
            subtitle: "Start working with a specialist agent tailored to your needs",
            background: AnyShapeStyle(Color(hex: "1D2426")),
            shineProgress: shine1
        )
    }
    
    var createAgentHeroCard: some View {
        AILargeHeroCard(
            iconName: "plus.circle.fill",
            title: "Create Your Agent",
            subtitle: "Build a custom AI agent perfectly suited to your workflow",
            background: AnyShapeStyle(Color(hex: "BADEDD")),
            shineProgress: shine2,
            prefersLightForeground: false
        )
    }
    
    var selectAgentHeroCard: some View {
        AILargeHeroCard(
            iconName: "person.3.fill",
            title: "Choose an Agent",
            subtitle: "Pick an agent from your library and start right away",
            background: AnyShapeStyle(LinearGradient(
                colors: [Color(hex: "F0F0F0"), Color(hex: "E5E5E5")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )),
            shineProgress: shine3,
            prefersLightForeground: false
        )
    }
}

private extension MessageBubble {
    var nonUserBubbleBackground: Color { Color(.secondarySystemBackground) }
}

private extension TypingIndicator {
    var secondaryBackground: Color { Color(.secondarySystemBackground) }
}

// MARK: - Reusable Action Card
private struct AIActionCard: View {
    let iconName: String
    let title: String
    let subtitle: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppConstants.Colors.primary)
                .frame(width: 44, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(iconBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(AppConstants.Colors.primary.opacity(0.06), lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(cardBackground)
        )
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
    
    private var iconBackground: Color {
        colorScheme == .dark ? Color.white.opacity(0.12) : AppConstants.Colors.surface
    }
    
    private var cardBackground: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : AppConstants.Colors.surfaceStrong
    }
}

// MARK: - Large Hero Card (Brand-focused, modern pattern)
private struct AILargeHeroCard: View {
    let iconName: String
    let title: String
    let subtitle: String
    var background: AnyShapeStyle? = nil
    var shineProgress: CGFloat = -0.2
    var prefersLightForeground: Bool = true
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Clean modern background with subtle depth
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(background ?? AnyShapeStyle(heroBackground))
                .overlay(
                    // Subtle top light reflection
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                )
                .shadow(
                    color: Color.black.opacity(0.06),
                    radius: 8,
                    x: 0,
                    y: 3
                )
            
            // Content with clean layout
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    // Clean modern icon design
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(0.15))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: iconName)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(foreground)
                    )
                
                    // Text content with clean typography
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(foreground)
                        .lineLimit(1)
                        
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(foregroundSecondary)
                        .lineLimit(2)
                            .multilineTextAlignment(.leading)
                }
                
                Spacer()
                }
                
                // Simple action indicator
                HStack {
                    Spacer()
                    Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(foregroundSecondary)
                }
            }
            .padding(20)
        }
    }
    
    private var heroBackground: AnyShapeStyle { AnyShapeStyle(Color(hex: "0A1213")) }
    
    // Deprecated custom overlay replaced by ModernCardOverlay

    private var foreground: Color {
        prefersLightForeground ? .white : AppConstants.Colors.primary
    }
    private var foregroundSecondary: Color {
        prefersLightForeground ? Color.white.opacity(0.85) : AppConstants.Colors.primary.opacity(0.75)
    }
    private var foregroundBase: Color {
        prefersLightForeground ? .white : AppConstants.Colors.primary
    }
}
