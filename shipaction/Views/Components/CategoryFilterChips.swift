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
                    .fill(chipBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(chipBorderColor, lineWidth: chipBorderWidth)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Dynamic Colors for Dark/Light Mode
    private var chipBackground: Color {
        if isSelected { 
            return AppConstants.Colors.turquoise 
        }
        // Dynamic background based on color scheme
        return colorScheme == .dark ? 
            Color.white.opacity(0.1) : 
            Color.gray.opacity(0.15)
    }
    
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