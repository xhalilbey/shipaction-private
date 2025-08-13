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
            // Card Content
            VStack(alignment: .leading, spacing: 12) {
                // Header with logo and category
                HStack(alignment: .top, spacing: 10) {
                    // Agent Logo
                    ZStack {
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(tokenBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(tokenStroke, lineWidth: 1)
                            )
                            .frame(width: 40, height: 40)
                        
                        if let logoURL = agent.logoURL, !logoURL.isEmpty {
                            AsyncImage(url: URL(string: logoURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Image("logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(AppConstants.Colors.primary)
                            }
                            .frame(width: 24, height: 24)
                        } else {
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(AppConstants.Colors.primary)
                                .frame(width: 24, height: 24)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Agent Name
                        Text(agent.name)
                            .font(.system(size: 14, weight: .semibold, design: .default))
                            .foregroundStyle(textPrimary)
                            .lineLimit(1)
                        
                        // Category Badge
                        HStack(spacing: 4) {
                            Image(systemName: agent.category.iconName)
                                .font(.system(size: 8, weight: .medium))
                                .foregroundStyle(accentText)
                            
                            Text(agent.category.displayName)
                                .font(.system(size: 9, weight: .medium))
                                .foregroundStyle(accentText)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(tokenBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .stroke(tokenStroke, lineWidth: 1)
                                )
                        )
                    }
                    
                    Spacer()
                }
                
                // Description
                Text(agent.description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Tags
                if !agent.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(agent.tags.prefix(3), id: \.self) { tag in
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
                                    )
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                }
                
                // Actions: Save (library), Detail and Start
                HStack(spacing: 8) {
                    // Save toggle using library icon (bookmark) – left side
                    Button(action: {
                        isSaved.toggle()
                        HapticFeedbackManager.shared.playSelection()
                    }) {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(colorScheme == .dark ? Color.white : AppConstants.Colors.primary)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.06) : AppConstants.Colors.surface)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel(isSaved ? "Saved" : "Save")

                    Spacer()
                    
                    // Detail Info Button
                    if let onDetailTapped = onDetailTapped {
                        Button(action: {
                            onDetailTapped(agent)
                            HapticFeedbackManager.shared.playLightImpact()
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(colorScheme == .dark ? Color.white : AppConstants.Colors.primary)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(colorScheme == .dark ? Color.white.opacity(0.06) : AppConstants.Colors.surface)
                                )
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .accessibilityLabel("View Details")
                    }

                    // Start Arrow Button
                    Button(action: {
                        onStartTapped(agent)
                        HapticFeedbackManager.shared.playLightImpact()
                    }) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(colorScheme == .dark ? Color.white : AppConstants.Colors.primary)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.06) : AppConstants.Colors.surface)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
                    .accessibilityLabel("Start Agent")
                }
            }
            .padding(12)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(cardBackground)
                .shadow(
                    color: .black.opacity(0.06),
                    radius: isPressed ? 6 : 8,
                    x: 0,
                    y: 2
                )
        )
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
    var cardBackground: Color { colorScheme == .dark ? AppConstants.Colors.primary : AppConstants.Colors.surfaceStrong }
    var tokenBackground: Color { colorScheme == .dark ? AppConstants.Colors.darkTokenBackground : AppConstants.Colors.surface }
    var tokenStroke: Color { colorScheme == .dark ? Color.white.opacity(0.10) : AppConstants.Colors.primary.opacity(0.06) }
    var textPrimary: Color { colorScheme == .dark ? Color.white : AppConstants.Colors.primaryText }
    var textSecondary: Color { colorScheme == .dark ? Color.white.opacity(0.75) : AppConstants.Colors.secondaryText }
    var accentText: Color { colorScheme == .dark ? .white : AppConstants.Colors.primary }
    var tagTextColor: Color { colorScheme == .dark ? .white : AppConstants.Colors.secondaryText }
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


