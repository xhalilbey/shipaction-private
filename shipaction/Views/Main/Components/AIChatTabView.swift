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
    private var colorScheme: ColorScheme { .light }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    
                    VStack(spacing: 12) {
                        hireAgentCard
                        selectAgentCard
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
            .background(backgroundColor)
            .tint(AppConstants.Colors.primary)
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
    var backgroundColor: Color { AppConstants.Colors.background }
    var headerForegroundColor: Color { AppConstants.Colors.primary }
    
    // Top bar same as Search
    var header: some View {
        HStack(spacing: 12) {
            Group {
                if colorScheme == .dark { // never true
                    Image("white_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(AppConstants.Colors.primary)
                }
            }
            .frame(width: 28, height: 28)
            .accessibilityHidden(true)
            
            Text("Shipaction")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(headerForegroundColor)
                .accessibilityIdentifier("brand_title")
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(headerForegroundColor)
            }
            .buttonStyle(.plain)
            .allowsHitTesting(false)
            .accessibilityLabel("Share app")
            .accessibilityHint("Coming soon")
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
    }
    
    // Cards
    var hireAgentCard: some View {
        AIActionCard(
            iconName: "briefcase.fill",
            title: "Agent işe alma",
            subtitle: "İhtiyacına uygun uzman bir Agent ile çalışmaya başla"
        )
    }
    
    var selectAgentCard: some View {
        AIActionCard(
            iconName: "person.3.fill",
            title: "Agent seç",
            subtitle: "Kütüphaneden bir Agent seç ve hemen kullan"
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