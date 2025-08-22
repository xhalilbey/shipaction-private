//
//  CategoryFilterChips.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Category Filter Chips

/// Horizontal scrollable category filter chips
struct CategoryFilterChips: View {
    
    let categories: [(category: AgentCategory, count: Int)]
    @Binding var selectedCategory: AgentCategory?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All Categories chip
                FilterChip(
                    title: "All",
                    count: nil,
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                // Category chips
                ForEach(categories, id: \.category) { item in
                    FilterChip(
                        title: item.category.displayName,
                        count: nil,
                        isSelected: selectedCategory == item.category
                    ) {
                        selectedCategory = item.category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let count: Int?
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                
                if let count = count {
                    Text("(\(count))")
                        .font(.system(size: 12, weight: .regular))
                        .opacity(0.8)
                }
            }
            .foregroundStyle(chipTextColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.clear : (colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.15)))
                    .overlay(
                        // Multi-color gradient overlay for selected state
                        Group {
                            if isSelected {
                                ZStack {
                                    // Base subtle background
                                    Color(hex: "1E1B4B").opacity(0.3)
                                    
                                    // RED - Top area
                                    RadialGradient(
                                        colors: [
                                            Color(hex: "DC2626").opacity(0.8),
                                            Color(hex: "EF4444").opacity(0.4),
                                            Color.clear
                                        ],
                                        center: UnitPoint(x: 0.7, y: 0.15),
                                        startRadius: 5,
                                        endRadius: 40
                                    )
                                    
                                    // ORANGE - Right side
                                    RadialGradient(
                                        colors: [
                                            Color(hex: "EA580C").opacity(0.7),
                                            Color(hex: "F97316").opacity(0.5),
                                            Color.clear
                                        ],
                                        center: UnitPoint(x: 0.85, y: 0.5),
                                        startRadius: 8,
                                        endRadius: 35
                                    )
                                    
                                    // YELLOW - Bottom right
                                    RadialGradient(
                                        colors: [
                                            Color(hex: "CA8A04").opacity(0.8),
                                            Color(hex: "EAB308").opacity(0.6),
                                            Color.clear
                                        ],
                                        center: UnitPoint(x: 0.75, y: 0.85),
                                        startRadius: 6,
                                        endRadius: 38
                                    )
                                    
                                    // GREEN - Bottom left
                                    RadialGradient(
                                        colors: [
                                            Color(hex: "16A34A").opacity(0.8),
                                            Color(hex: "22C55E").opacity(0.5),
                                            Color.clear
                                        ],
                                        center: UnitPoint(x: 0.25, y: 0.8),
                                        startRadius: 7,
                                        endRadius: 42
                                    )
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(chipBorderColor, lineWidth: chipBorderWidth)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Dynamic Colors for Dark/Light Mode
    
    private var chipTextColor: Color {
        if isSelected { 
            return .white 
        }
        // Dynamic text color based on color scheme
        return AppConstants.Colors.dynamicPrimaryText(colorScheme)
    }
    
    private var chipBorderColor: Color {
        if isSelected { 
            return .clear 
        }
        // Light border for better visibility in light mode
        return colorScheme == .dark ? 
            .clear : 
            Color.gray.opacity(0.2)
    }
    
    private var chipBorderWidth: CGFloat { 
        chipBorderColor == .clear ? 0 : 1 
    }
}