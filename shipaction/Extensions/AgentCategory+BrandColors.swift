//
//  AgentCategory+BrandColors.swift
//  shipaction
//
//  Created by Assistant on 08.08.2025.
//

import SwiftUI

// MARK: - AgentCategory Brand Colors

extension AgentCategory {
    /// Brand-driven gradient colors for each category.
    /// First color leans on the brand primary tone; second is a category accent.
    var brandGradientColors: [Color] {
        switch self {
        case .productivity:
            return [Color(hex: "0E5E5C"), Color(hex: "39A39D")] // teal → mint
        case .creative:
            return [Color(hex: "0E5E5C"), Color(hex: "7F56D9")] // teal → purple
        case .business:
            return [Color(hex: "0E5E5C"), Color(hex: "F2994A")] // teal → orange
        case .education:
            return [Color(hex: "0E5E5C"), Color(hex: "2D9CDB")] // teal → blue
        case .healthcare:
            return [Color(hex: "0E5E5C"), Color(hex: "27AE60")] // teal → green
        case .finance:
            return [Color(hex: "0E5E5C"), Color(hex: "10B981")] // teal → emerald
        case .marketing:
            return [Color(hex: "0E5E5C"), Color(hex: "EF4444")] // teal → red
        case .education_dev:
            return [Color(hex: "0E5E5C"), Color(hex: "3B82F6")] // teal → azure
        case .customer_service:
            return [Color(hex: "0E5E5C"), Color(hex: "F59E0B")] // teal → amber
        case .analytics:
            return [Color(hex: "0E5E5C"), Color(hex: "8B5CF6")] // teal → violet
        case .travel:
            return [Color(hex: "0E5E5C"), Color(hex: "06B6D4")] // teal → cyan
        case .ecommerce:
            return [Color(hex: "0E5E5C"), Color(hex: "14B8A6")] // teal → turquoise
        }
    }

    /// Primary accent color for the category (used for strokes and icons when unselected)
    var accentColor: Color {
        brandGradientColors.last ?? AppConstants.Colors.primary
    }

    /// Background gradient for category rows based on selection state.
    func rowBackgroundGradient(isSelected: Bool) -> LinearGradient {
        let start = brandGradientColors.first ?? AppConstants.Colors.primary
        let end = brandGradientColors.last ?? AppConstants.Colors.primary
        let colors = isSelected
        ? [end.opacity(0.28), start.opacity(0.20)]
        : [end.opacity(0.12), start.opacity(0.08)]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    /// Icon background gradient tuned to selection state.
    func iconBackground(isSelected: Bool) -> LinearGradient {
        let start = accentColor.opacity(isSelected ? 0.95 : 0.14)
        let end = AppConstants.Colors.primary.opacity(isSelected ? 0.95 : 0.12)
        return LinearGradient(colors: [start, end], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}


