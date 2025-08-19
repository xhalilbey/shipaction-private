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
    let onSelect: (MainTab) -> Void
    @Environment(\.colorScheme) private var colorScheme

    init(
        selectedTab: Binding<MainTab>,
        onSelect: @escaping (MainTab) -> Void = { _ in }
    ) {
        self._selectedTab = selectedTab
        self.onSelect = onSelect
    }
    
    // MARK: - Animation States
    @State private var isPressed = false
    @State private var pressedTab: MainTab?
    @State private var iconBounce: [MainTab: Bool] = [:]
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(MainTab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8) // Sits directly on bottom edge
        .background(
            // Subtle top border
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(colorScheme == .dark ? 0.2 : 0.1),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 0.5)
                .offset(y: -12),
            alignment: .top
        )
        .onAppear {
            // Initialize bounce states
            for tab in MainTab.allCases {
                iconBounce[tab] = false
            }
        }
    }
    
    // MARK: - Tab Button
    
    @ViewBuilder
    private func tabButton(for tab: MainTab) -> some View {
        VStack(spacing: 6) {
            // Clean icon without background
            tabIcon(for: tab)
                .scaleEffect(iconBounce[tab] == true ? 1.2 : (selectedTab == tab ? 1.1 : 1.0))
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: iconBounce[tab])
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
                .frame(height: 32)
            
            // Enhanced tab label
            tabLabel(for: tab)
                .opacity(selectedTab == tab ? 1.0 : 0.7)
        }
        .scaleEffect(isPressed && pressedTab == tab ? 0.92 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isPressed)
        .onTapGesture {
            performTabSelection(tab)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                        pressedTab = tab
                        
                        // Trigger haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }
                }
                .onEnded { _ in
                    isPressed = false
                    pressedTab = nil
                }
        )
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
    
    // MARK: - Tab Selection Logic
    private func performTabSelection(_ tab: MainTab) {
        // Trigger bounce animation
        iconBounce[tab] = true
        
        // Reset bounce after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            iconBounce[tab] = false
        }
        
        // Medium haptic feedback for selection
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Perform selection
        onSelect(tab)
    }
    
    // MARK: - Color Helpers
    
    private func iconColor(for tab: MainTab) -> Color {
        if selectedTab == tab {
            return AppConstants.Colors.turquoise
        }
        // Dynamic inactive color with better visibility
        return colorScheme == .dark ? 
            Color.white.opacity(0.75) : 
            Color.black.opacity(0.65)
    }

    private func textColor(for tab: MainTab) -> Color {
        if selectedTab == tab {
            return AppConstants.Colors.turquoise
        }
        // Dynamic inactive color with better visibility
        return colorScheme == .dark ? 
            Color.white.opacity(0.75) : 
            Color.black.opacity(0.65)
    }

    // MARK: - Subviews



    @ViewBuilder
    private func tabIcon(for tab: MainTab) -> some View {
        Image(systemName: tab.iconName)
            .font(
                .system(
                    size: selectedTab == tab ? 20 : 18,
                    weight: selectedTab == tab ? .semibold : .medium,
                    design: .rounded
                )
            )
            .foregroundStyle(iconColor(for: tab))
            .symbolEffect(
                .bounce.down,
                options: .nonRepeating,
                value: selectedTab == tab
            )

            // ⚙️ Gear rotation for Settings tab - smooth spinning gear
            .symbolEffect(
                .rotate.byLayer,
                options: selectedTab == tab && tab == .profile ? .speed(0.4).repeating : .nonRepeating,
                value: selectedTab == tab && tab == .profile
            )
    }

    @ViewBuilder
    private func tabLabel(for tab: MainTab) -> some View {
        Text(tab.displayText)
            .font(
                .system(
                    size: selectedTab == tab ? 11 : 10,
                    weight: selectedTab == tab ? .semibold : .medium,
                    design: .rounded
                )
            )
            .foregroundStyle(textColor(for: tab))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .scaleEffect(selectedTab == tab ? 1.0 : 0.95)
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
    }
    
    // MARK: - Actions (delegated via onSelect)

}



// MARK: - Tab Bar Container

/// Enhanced TabBar Container with improved layout
struct StandardTabBarContainer<Content: View>: View {
    
    // MARK: - Properties
    
    @Binding var selectedTab: MainTab
    let content: Content
    let onSelectTab: (MainTab) -> Void

    init(
        selectedTab: Binding<MainTab>,
        onSelectTab: @escaping (MainTab) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self._selectedTab = selectedTab
        self.onSelectTab = onSelectTab
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content with proper padding
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 72) // Fine-tuned spacing to sit closer to bottom edge
                .background(containerBackground)
            
            // Tab bar with background and proper positioning (selection delegated)
            StandardTabBar(
                selectedTab: $selectedTab,
                onSelect: onSelectTab
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
    @Environment(\.colorScheme) private var colorScheme
    private var containerBackground: Color { 
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
}

// MARK: - Preview

#Preview {
    StandardTabBarContainer(selectedTab: .constant(.home)) {
        Color.gray.opacity(0.1)
    }
} 