//
//  CategoryRow.swift
//  shipaction
//
//  Created by Assistant on 08.08.2025.
//

import SwiftUI

// MARK: - Category Row

/// Row component for displaying a category in the search view
struct CategoryRow: View {
    let category: AgentCategory
    let isSelected: Bool
    let onTap: () -> Void
    var namespace: Namespace.ID?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationLink(value: category) {
            ZStack {
                if isSelected, let ns = namespace {
                    // Simple turquoise background for selected category
                    Color(hex: "1FB8CD")
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .matchedGeometryEffect(id: "row-bg-\(category.rawValue)", in: ns)
                }
                
                HStack(spacing: 12) {
                    // Icon
                    categoryIcon
                    
                    // Title
                    categoryTitle
                    
                    Spacer()
                    
                    // Trailing indicator
                    trailingIndicator
                }
                .padding(14)
            }
            .background(cardBackground)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: isSelected)
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var categoryIcon: some View {
        Group {
            if let ns = namespace, isSelected {
                Image(systemName: category.iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(categoryIconForeground)
                    .frame(width: 36, height: 36)
                    .background(iconBackgroundView)
                    .matchedGeometryEffect(id: "icon-\(category.rawValue)", in: ns, isSource: true)
            } else {
                Image(systemName: category.iconName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(categoryIconForeground)
                    .frame(width: 36, height: 36)
                    .background(iconBackgroundView)
            }
        }
    }
    
    private var iconBackgroundView: some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(iconBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(iconStroke, lineWidth: 1)
            )
    }
    
    private var categoryTitle: some View {
        Text(category.displayName)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(categoryTextColor)
    }
    
    private var trailingIndicator: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(trailingIndicatorColor(isSelected: isSelected))
    }
    
    // MARK: - Card Background
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(modernCardBackground)
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
                    colors: [Color.gray.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: colorScheme == .dark ? 1 : 1
            )
    }
    
    @ViewBuilder
    private var shadowOverlay: some View {
        Group {
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
    }
    
    // MARK: - Colors
    
    private var modernCardBackground: some ShapeStyle {
        if colorScheme == .dark {
            return AnyShapeStyle(Color(hex: "1D1C1C"))
        } else {
            // Use same dark color as "Hire an Agent" card
            return AnyShapeStyle(Color(hex: "1D2426"))
        }
    }
    

    
    private var categoryIconForeground: some ShapeStyle {
        // Always use white for both selected and unselected states, both light and dark mode
        return AnyShapeStyle(Color.white)
    }
    

    
    private var iconBackground: Color {
        // Use consistent color like AgentCard tokenBackground for both light and dark mode
        Color.white.opacity(0.15)
    }
    
    private var iconStroke: Color {
        // Use consistent color like AgentCard tokenStroke for both light and dark mode
        Color.white.opacity(0.25)
    }
    
    private var categoryTextColor: Color {
        if isSelected {
            return Color.white // Always white on gradient background
        }
        // Use white text on dark background for both modes
        return Color.white
    }
    
    private func trailingIndicatorColor(isSelected: Bool) -> Color {
        if isSelected {
            return Color.white // Always white on gradient background
        } else {
            // Use white with opacity on dark background for both modes
            return Color.white.opacity(0.7)
        }
    }
}


