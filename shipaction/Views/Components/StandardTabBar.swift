//
//  StandardTabBar.swift
//  payaction-ios
//
//  Created by Halil Eren on 16.06.2025.
//
//  Modern iOS 17/18 uyumlu gelişmiş TabBar tasarımı

import SwiftUI

// MARK: - Enhanced Tab Bar

/// Modern iOS 17/18 gelişmiş TabBar implementasyonu
/// 
/// Features:
/// - Modern visual hierarchy
/// - Smooth animations
/// - Enhanced spacing & typography
/// - Subtle shadows & depth
/// - Haptic feedback
/// - Accessibility support
struct StandardTabBar: View {
    
    // MARK: - Properties
    
    @Binding var selectedTab: MainTab
    @Namespace private var animation
    let onSelect: (MainTab) -> Void = { _ in }
    
    // MARK: - Animation States
    @State private var isPressed = false
    @State private var pressedTab: MainTab?
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 8) // Tighter bottom inset to sit closer to device edge

    }
    
    // MARK: - Tab Button
    
    @ViewBuilder
    private func tabButton(for tab: MainTab) -> some View {
        VStack(spacing: 6) {
            // Icon container with enhanced selection state
            ZStack {
                // Selection background with improved design
                if selectedTab == tab {
                                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(AppConstants.Colors.primary)
                        .frame(width: 52, height: 32)
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        .matchedGeometryEffect(id: "selectedTab", in: animation)
                }
                
                // Tab icon with enhanced styling
                Image(systemName: tab.iconName)
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(iconColor(for: tab))
                    .scaleEffect(selectedTab == tab ? 1.0 : 0.9)
            }
            .frame(height: 32)
            
            // Tab label with improved typography
            Text(tab.displayText)
                .font(.system(size: 10, weight: selectedTab == tab ? .semibold : .medium, design: .rounded))
                .foregroundStyle(textColor(for: tab))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .scaleEffect(isPressed && pressedTab == tab ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isPressed)
        .onTapGesture { onSelect(tab) }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
    
    // MARK: - Color Helpers
    
    private var colorScheme: ColorScheme { .light }
    
    private func iconColor(for tab: MainTab) -> Color {
        if colorScheme == .dark { return .white }
        return selectedTab == tab ? .white : AppConstants.Colors.primary
    }
    
    private func textColor(for tab: MainTab) -> Color {
        if colorScheme == .dark { return .white }
        return selectedTab == tab ? AppConstants.Colors.primary : AppConstants.Colors.primary
    }
    
    // MARK: - Actions
    private func selectTab(_ tab: MainTab) {
        onSelect(tab)
    }



// MARK: - Tab Bar Container

/// Enhanced TabBar Container with improved layout
struct StandardTabBarContainer<Content: View>: View {
    
    // MARK: - Properties
    
    @Binding var selectedTab: MainTab
    @ViewBuilder let content: Content
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content with proper padding
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 72) // Fine-tuned spacing to sit closer to bottom edge
                .background(containerBackground)
            
            // Tab bar with background and proper positioning
            StandardTabBar(
                selectedTab: $selectedTab,
                onSelect: { tab in
                    withAnimation(
                        .spring(
                            response: 0.5,
                            dampingFraction: 0.7,
                            blendDuration: 0
                        )
                    ) {
                        selectedTab = tab
                    }
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
            )
                .background(
                    Rectangle()
                        .fill(containerBackground)
                        .ignoresSafeArea(.all)
                )
                .padding(.horizontal, 0) // Remove horizontal padding to reach edges
                .padding(.bottom, 0) // Remove bottom padding to reach bottom
        }
        .background(containerBackground)
        .ignoresSafeArea(.keyboard)
    }

    // MARK: - Color Scheme Aware Background
    private var colorScheme: ColorScheme { .light }
    private var containerBackground: Color { AppConstants.Colors.background }
}

// MARK: - Preview

#Preview {
    StandardTabBarContainer(selectedTab: .constant(.home)) {
        Color.gray.opacity(0.1)
    }
} 