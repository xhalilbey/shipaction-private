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
        VStack {
            Spacer()
            
            Text("Çok yakında")
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
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
}

private extension MessageBubble {
    var nonUserBubbleBackground: Color { Color(.secondarySystemBackground) }
}

private extension TypingIndicator {
    var secondaryBackground: Color { Color(.secondarySystemBackground) }
}