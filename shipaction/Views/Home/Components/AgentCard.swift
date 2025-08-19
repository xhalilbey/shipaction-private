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
                .fill(tokenBackground)
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
                .foregroundStyle(textPrimary)
            
            Text(agent.category.displayName)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(textPrimary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(tokenBackground)
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
                    .fill(tokenBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(tokenStroke, lineWidth: 1)
                    )
                    .shadow(color: colorScheme == .dark ? .black.opacity(0.05) : .clear, radius: 1, x: 0, y: 0.5)
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
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(actionIconColor)
                .frame(width: 36, height: 36)
                .background(actionButtonBackground)
                .shadow(color: colorScheme == .dark ? .black.opacity(0.1) : .clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(isSaved ? "Saved" : "Save")
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
                            .fill(tokenBackground)
                            .overlay(
                                Circle()
                                    .stroke(tokenStroke, lineWidth: 1)
                            )
                    )
                    .shadow(color: colorScheme == .dark ? .black.opacity(0.1) : .clear, radius: 4, x: 0, y: 2)
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
            .fill(tokenBackground)
            .overlay(
                Circle()
                    .stroke(tokenStroke, lineWidth: 1)
            )
            .shadow(color: colorScheme == .dark ? .black.opacity(0.1) : .clear, radius: 2, x: 0, y: 1)
    }
    
    // MARK: - Card Background
    private var cardBackgroundView: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(modernCardBackground)
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
    var cardBackground: LinearGradient { 
        LinearGradient(colors: [Color(hex: "20808D"), Color(hex: "20808D").opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var modernCardBackground: Color {
        colorScheme == .dark ? 
            Color(hex: "1D1C1C") : 
            AppConstants.Colors.lightCardSecondary
    }
    var tokenBackground: Color { 
        colorScheme == .dark ? 
            Color.white.opacity(0.1) : 
            Color.white.opacity(0.4)
    }
    var tokenStroke: Color { 
        colorScheme == .dark ? 
            Color.white.opacity(0.2) : 
            Color.white.opacity(0.6)
    }
    var textPrimary: Color { 
        colorScheme == .dark ? 
            Color.white : 
            AppConstants.Colors.lightPrimaryText
    }
    var textSecondary: Color { 
        colorScheme == .dark ? 
            Color.white.opacity(0.95) : 
            AppConstants.Colors.lightSecondaryText.opacity(0.9)
    }
    var accentText: Color { 
        colorScheme == .dark ? 
            Color.white.opacity(0.98) : 
            AppConstants.Colors.lightPrimaryText.opacity(0.95)
    }
    var tagTextColor: Color { 
        colorScheme == .dark ? 
            Color.white.opacity(0.95) : 
            Color.black.opacity(0.8)
    }
    var actionIconColor: Color {
        colorScheme == .dark ? 
            Color(hex: "1FB8CD") : 
            Color.black.opacity(0.8)
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


