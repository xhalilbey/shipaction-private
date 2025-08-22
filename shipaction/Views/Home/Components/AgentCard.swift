//
//  AgentCard.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Agent Card

/// Modern card component for displaying AI agents in marketplace style
struct AgentCard: View {
    
    // MARK: - Properties
    
    let agent: Agent
    let onStartTapped: (Agent) -> Void
    let onDetailTapped: ((Agent) -> Void)?
    
    // MARK: - Initializers (backward-compatible)
    init(
        agent: Agent,
        onStartTapped: @escaping (Agent) -> Void,
        onDetailTapped: ((Agent) -> Void)? = nil
    ) {
        self.agent = agent
        self.onStartTapped = onStartTapped
        self.onDetailTapped = onDetailTapped
    }
    
    /// Backward-compatible initializer to preserve old call sites
    init(
        agent: Agent,
        onStartTapped: @escaping (Agent) -> Void
    ) {
        self.init(
            agent: agent,
            onStartTapped: onStartTapped,
            onDetailTapped: nil
        )
    }
    
    // MARK: - State
    
    @State private var isPressed = false
    @State private var isSaved = false
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            cardContentView
        }
        .background(cardBackgroundView)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .onTapGesture {
            // Card tap gesture can be used for navigation to detail view
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, perform: {}, onPressingChanged: { pressing in
            isPressed = pressing
        })
    }
    
    // MARK: - Card Content
    private var cardContentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            cardHeaderView
            descriptionView
            tagsView
            actionsView
        }
        .padding(16)
    }
    
    // MARK: - Card Header
    private var cardHeaderView: some View {
        HStack(alignment: .top, spacing: 10) {
            agentLogoView
            agentInfoView
            Spacer()
        }
    }
    
    // MARK: - Agent Logo
    private var agentLogoView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.clear) // Transparent background
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(tokenStroke, lineWidth: 1)
                )
                .frame(width: 48, height: 48)
            
            Image(systemName: "apple.logo")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(textPrimary)
                .frame(width: 28, height: 28)
        }
    }
    
    // MARK: - Agent Info
    private var agentInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            agentNameView
            categoryBadgeView
        }
    }
    
    // MARK: - Agent Name
    private var agentNameView: some View {
        Text(agent.name)
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(textPrimary)
            .lineLimit(1)
            .shadow(color: colorScheme == .dark ? .black.opacity(0.3) : .clear, radius: 1, x: 0, y: 1)
    }
    
    // MARK: - Category Badge
    private var categoryBadgeView: some View {
        HStack(spacing: 4) {
            Image(systemName: agent.category.iconName)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(Color.white)
            
            Text(agent.category.displayName)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(textPrimary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.clear) // Transparent background
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(tokenStroke, lineWidth: 1)
                )
        )
    }
                
    // MARK: - Description
    private var descriptionView: some View {
        Text(agent.description)
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundStyle(textSecondary)
            .lineLimit(2)
            .lineSpacing(3)
            .multilineTextAlignment(.leading)
            .shadow(color: colorScheme == .dark ? .black.opacity(0.2) : .clear, radius: 1, x: 0, y: 0.5)
    }
    
    // MARK: - Tags
    @ViewBuilder
    private var tagsView: some View {
        if !agent.tags.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(agent.tags.prefix(3), id: \.self) { tag in
                        tagView(tag)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
    
    // MARK: - Individual Tag
    private func tagView(_ tag: String) -> some View {
        Text(tag)
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(tagTextColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.clear) // Transparent background
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(tokenStroke, lineWidth: 1)
                    )
            )
    }
    
    // MARK: - Actions
    private var actionsView: some View {
        HStack(spacing: 8) {
            saveButton
            detailButton
            Spacer()
            startButton
        }
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: {
            isSaved.toggle()
            HapticFeedbackManager.shared.playSelection()
        }) {
            Image(systemName: isSaved ? "star.fill" : "star")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(actionIconColor)
                .frame(width: 36, height: 36)
                .background(actionButtonBackground)
                .shadow(color: colorScheme == .dark ? .black.opacity(0.1) : .clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(isSaved ? "Starred" : "Star")
    }
    
    // MARK: - Detail Button
    @ViewBuilder
    private var detailButton: some View {
        if let onDetailTapped = onDetailTapped {
            Button(action: {
                onDetailTapped(agent)
                HapticFeedbackManager.shared.playLightImpact()
            }) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(actionIconColor)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.clear) // Transparent background
                            .overlay(
                                Circle()
                                    .stroke(tokenStroke, lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel("View details")
        }
    }
    
    // MARK: - Start Button
    private var startButton: some View {
        Button(action: {
            onStartTapped(agent)
            HapticFeedbackManager.shared.playLightImpact()
        }) {
            Image(systemName: "arrow.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(actionIconColor)
                .frame(width: 36, height: 36)
                .background(actionButtonBackground)
                .shadow(color: colorScheme == .dark ? .black.opacity(0.1) : .clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .accessibilityLabel("Start Agent")
    }
    
    // MARK: - Action Button Background
    private var actionButtonBackground: some View {
        Circle()
            .fill(Color.clear) // Transparent background
            .overlay(
                Circle()
                    .stroke(tokenStroke, lineWidth: 1)
            )
    }
    
    // MARK: - Card Background
    private var cardBackgroundView: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .overlay(
                // Balanced color distribution - Red, Green, Yellow, Orange prominent
                ZStack {
                    // Base subtle background
                    Color(hex: "1E1B4B").opacity(0.3) // Deep purple base
                    
                    // RED - Top area (more prominent)
                    RadialGradient(
                        colors: [
                            Color(hex: "DC2626").opacity(0.8), // Strong red
                            Color(hex: "EF4444").opacity(0.4),
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.7, y: 0.15),
                        startRadius: 20,
                        endRadius: 180
                    )
                    
                    // ORANGE - Right side (prominent)
                    RadialGradient(
                        colors: [
                            Color(hex: "EA580C").opacity(0.7), // Strong orange
                            Color(hex: "F97316").opacity(0.5),
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.85, y: 0.5),
                        startRadius: 25,
                        endRadius: 170
                    )
                    
                    // YELLOW - Bottom right (prominent)
                    RadialGradient(
                        colors: [
                            Color(hex: "CA8A04").opacity(0.8), // Strong yellow
                            Color(hex: "EAB308").opacity(0.6),
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.75, y: 0.85),
                        startRadius: 30,
                        endRadius: 160
                    )
                    
                    // GREEN - Bottom left (prominent)
                    RadialGradient(
                        colors: [
                            Color(hex: "16A34A").opacity(0.8), // Strong green
                            Color(hex: "22C55E").opacity(0.5),
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.25, y: 0.8),
                        startRadius: 35,
                        endRadius: 175
                    )
                    
                    // Purple accent - Top left (supporting)
                    RadialGradient(
                        colors: [
                            Color(hex: "7C3AED").opacity(0.6), // Supporting purple
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.15, y: 0.2),
                        startRadius: 15,
                        endRadius: 120
                    )
                    
                    // Blue accent - Left side (supporting)
                    RadialGradient(
                        colors: [
                            Color(hex: "2563EB").opacity(0.5), // Supporting blue
                            Color.clear
                        ],
                        center: UnitPoint(x: 0.1, y: 0.6),
                        startRadius: 20,
                        endRadius: 130
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            )
            .overlay(innerGlowOverlay)
            .overlay(borderGlowOverlay)
            .shadow(
                color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.clear,
                radius: isPressed ? 4 : 8,
                x: 0,
                y: isPressed ? 2 : 4
            )
            .shadow(
                color: colorScheme == .dark ? Color.white.opacity(0.15) : Color.clear,
                radius: 3,
                x: 0,
                y: -1
            )
    }
    
    // MARK: - Inner Glow Overlay
    @ViewBuilder
    private var innerGlowOverlay: some View {
        if colorScheme == .dark {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.03),
                            Color.clear
                        ],
                        center: .topLeading,
                        startRadius: 10,
                        endRadius: 150
                    )
                )
        }
    }
    
    // MARK: - Border Glow Overlay
    @ViewBuilder
    private var borderGlowOverlay: some View {
        if colorScheme == .dark {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.15),
                            Color.white.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        } else {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.12), lineWidth: 0.5)
        }
    }
}

// MARK: - AgentPrice Extension

extension AgentPrice {
    var isFreePricing: Bool {
        switch self {
        case .free:
            return true
        case .oneTime, .subscription:
            return false
        }
    }
}

// MARK: - Dark Mode Helpers
private extension AgentCard {
    // Remove the problematic cardBackground property since we're using it directly in cardBackgroundView
    
    var modernCardBackground: Color {
        colorScheme == .dark ? 
            Color(hex: "1D1C1C") : 
            AppConstants.Colors.lightCardSecondary
    }
    var tokenBackground: Color { 
        // Glass-like background for tokens on hero gradient
        Color.white.opacity(0.15)
    }
    var tokenStroke: Color { 
        // Subtle glass stroke for tokens on hero gradient  
        Color.white.opacity(0.25)
    }
    var textPrimary: Color { 
        // Use white text on hero-style gradient background like the original
        Color.white
    }
    var textSecondary: Color { 
        // Use white text with opacity on hero-style gradient background
        Color.white.opacity(0.9)
    }
    var accentText: Color { 
        // Use white accent text on hero gradient background
        Color.white.opacity(0.95)
    }
    var tagTextColor: Color { 
        // Use white tag text on hero gradient background
        Color.white.opacity(0.9)
    }
    var actionIconColor: Color {
        // Use white action icons on hero gradient background
        Color.white
    }

}

// MARK: - Preview

#Preview {
    ScrollView {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(Agent.sampleAgents.prefix(4)) { agent in
                AgentCard(
                    agent: agent,
                    onStartTapped: { agent in
                        print("Starting agent: \(agent.name)")
                    },
                    onDetailTapped: { agent in
                        print("Showing details for: \(agent.name)")
                    }
                )
            }
        }
        .padding(16)
    }
    .background(Color(.systemGroupedBackground))
}


