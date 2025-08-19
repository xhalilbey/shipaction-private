//
//  SearchResultCard.swift
//  shipaction
//
//  Created by Assistant on 08.08.2025.
//

import SwiftUI

// MARK: - Search Result Card

/// Card component for displaying search results
struct SearchResultCard: View {
    let result: SearchResult
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            iconView
            
            // Content
            contentView
            
            Spacer()
            
            // Chevron
            chevronView
        }
        .padding(16)
        .background(cardBackground)
    }
    
    // MARK: - Subviews
    
    private var iconView: some View {
        Image(systemName: "sparkles")
            .font(.title2)
            .foregroundStyle(Color(hex: "1FB8CD"))
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(modernSearchCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(result.title)
                .font(.headline)
                .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                .lineLimit(1)
            
            Text(result.description)
                .font(.subheadline)
                .foregroundStyle(AppConstants.Colors.dynamicSecondaryText(colorScheme))
                .lineLimit(2)
        }
    }
    
    private var chevronView: some View {
        Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundStyle(AppConstants.Colors.dynamicSecondaryText(colorScheme))
    }
    
    // MARK: - Card Background
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(modernSearchCardBackground)
            .overlay(innerGlowOverlay)
            .overlay(borderOverlay)
            .overlay(shadowOverlay)
    }
    
    @ViewBuilder
    private var innerGlowOverlay: some View {
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
    
    @ViewBuilder
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(
                colorScheme == .dark ? 
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.4),
                        Color.white.opacity(0.15),
                        Color.white.opacity(0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ) : 
                LinearGradient(
                    colors: [Color.black.opacity(0.12)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: colorScheme == .dark ? 1 : 0.5
            )
    }
    
    @ViewBuilder
    private var shadowOverlay: some View {
        if colorScheme == .dark {
            Color.clear
                .shadow(
                    color: Color.black.opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 4
                )
                .shadow(
                    color: Color.white.opacity(0.15),
                    radius: 3,
                    x: 0,
                    y: -1
                )
        }
    }
    
    // MARK: - Colors
    
    private var modernSearchCardBackground: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color.gray.opacity(0.18)
    }
}
