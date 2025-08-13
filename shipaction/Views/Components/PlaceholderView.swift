//
//  PlaceholderView.swift
//  payaction-ios
//
//  Created by Halil Eren on 16.06.2025.
//
//  Reusable placeholder component following DRY principles

import SwiftUI

// MARK: - Placeholder View

/// A reusable placeholder view component that displays consistent UI
/// for content that is not yet implemented or is loading.
/// 
/// This component eliminates code duplication across tab views and
/// provides a consistent visual experience while maintaining clean architecture.
/// 
/// Features:
/// - Consistent visual design across all placeholders
/// - Configurable title and description
/// - Optional icon display
/// - Loading state support
/// - Accessibility compliance
struct PlaceholderView: View {
    
    // MARK: - Properties
    
    /// Main title displayed prominently
    let title: String
    
    /// Descriptive text providing additional context
    let description: String
    
    /// Optional SF Symbol icon name
    let iconName: String?
    
    /// Whether to show loading indicator
    let isLoading: Bool
    
    /// Optional custom action button
    let action: (() -> Void)?
    
    /// Action button title
    let actionTitle: String?
    
    // MARK: - Initialization
    
    /// Creates a placeholder view with the specified configuration.
    /// 
    /// - Parameters:
    ///   - title: Main title to display
    ///   - description: Descriptive text
    ///   - iconName: Optional SF Symbol icon
    ///   - isLoading: Whether to show loading state
    ///   - actionTitle: Optional action button title
    ///   - action: Optional action closure
    init(
        title: String,
        description: String,
        iconName: String? = nil,
        isLoading: Bool = false,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isLoading = isLoading
        self.actionTitle = actionTitle
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Top spacer for consistent positioning
                        Spacer()
                            .frame(height: geometry.size.height * 0.2)
                        
                        // Content container
                        VStack(spacing: 24) {
                            // Icon section
                            if let iconName = iconName {
                                iconSection(iconName: iconName)
                            }
                            
                            // Text content
                            textContent
                            
                            // Loading indicator
                            if isLoading {
                                loadingSection
                            }
                            
                            // Optional action button
                            if let actionTitle = actionTitle, let action = action {
                                actionButton(title: actionTitle, action: action)
                            }
                        }
                        .padding(.horizontal, AppConstants.UI.horizontalPadding)
                        
                        // Bottom spacer
                        Spacer()
                            .frame(height: geometry.size.height * 0.3)
                    }
                }
            }
            .background(AppConstants.Colors.background)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - View Components
    
    /// Icon section with consistent styling
    @ViewBuilder
    private func iconSection(iconName: String) -> some View {
        ZStack {
            Circle()
                .fill(Color(.systemGray6))
                .frame(width: 100, height: 100)
            
            Circle()
                .fill(.black.opacity(0.03))
                .frame(width: 85, height: 85)
            
            Image(systemName: iconName)
                .font(.system(size: 36, weight: .medium, design: .rounded))
                .foregroundStyle(.primary)
        }
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        .accessibilityHidden(true) // Decorative icon
    }
    
    /// Text content section
    private var textContent: some View {
        VStack(spacing: 12) {
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            
            Text(description)
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(description)")
    }
    
    /// Loading section with spinner
    private var loadingSection: some View {
        VStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                .scaleEffect(1.2)
            
            Text("Loading content...")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .padding(.top, 8)
    }
    
    /// Action button with consistent styling
    @ViewBuilder
    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppConstants.Colors.primary)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .accessibilityLabel(title)
        .accessibilityHint("Starts \(title.lowercased()) action")
        .accessibilityAddTraits(.isButton)
        .padding(.top, 8)
        .padding(.horizontal, 32)
    }
}

// MARK: - Placeholder View Factory

/// Factory methods for creating common placeholder configurations
extension PlaceholderView {
    
    /// Creates a home placeholder view
    static func home(isLoading: Bool = false) -> PlaceholderView {
        PlaceholderView(
            title: LocalizedStrings.Home.title,
            description: LocalizedStrings.Home.description,
            iconName: "house.fill",
            isLoading: isLoading
        )
    }
    
    /// Creates a search placeholder view
    static func search(isLoading: Bool = false, onStartSearch: (() -> Void)? = nil) -> PlaceholderView {
        PlaceholderView(
            title: LocalizedStrings.Search.title,
            description: LocalizedStrings.Search.description,
            iconName: "magnifyingglass",
            isLoading: isLoading,
            actionTitle: onStartSearch != nil ? "Start Searching" : nil,
            action: onStartSearch
        )
    }
    
    /// Creates an AI chat placeholder view
    static func aiChat(isLoading: Bool = false, onStartChat: (() -> Void)? = nil) -> PlaceholderView {
        PlaceholderView(
            title: LocalizedStrings.AIChat.title,
            description: LocalizedStrings.AIChat.description,
            iconName: "brain.head.profile",
            isLoading: isLoading,
            actionTitle: onStartChat != nil ? "Start Conversation" : nil,
            action: onStartChat
        )
    }
    
    /// Creates a library placeholder view
    static func library(isLoading: Bool = false) -> PlaceholderView {
        PlaceholderView(
            title: LocalizedStrings.Library.title,
            description: LocalizedStrings.Library.description,
            iconName: "bookmark.fill",
            isLoading: isLoading
        )
    }
    
    /// Creates a cart placeholder view
    static func cart(isLoading: Bool = false, onStartShopping: (() -> Void)? = nil) -> PlaceholderView {
        PlaceholderView(
            title: LocalizedStrings.Cart.title,
            description: LocalizedStrings.Cart.description,
            iconName: "cart.fill",
            isLoading: isLoading,
            actionTitle: onStartShopping != nil ? "Start Shopping" : nil,
            action: onStartShopping
        )
    }
}

// MARK: - Localized Strings

/// Centralized string constants for localization support
enum LocalizedStrings {
    enum Home {
        static let title = "Home"
        static let description = "Home content coming soon. You'll be able to access all PayAction features from here."
    }
    
    enum Search {
        static let title = "Search"
        static let description = "Find everything you're looking for. Advanced search features for users, transactions, and more."
    }
    
    enum AIChat {
        static let title = "AI Assistant"
        static let description = "Chat with our AI assistant. Ask questions, get help, and use PayAction more efficiently."
    }
    
    enum Library {
        static let title = "Library"
        static let description = "Your saved items, favorite transactions, and personal collection will be here."
    }
    
    enum Cart {
        static let title = "Cart"
        static let description = "A modern and secure experience for your shopping cart and payment transactions."
    }
}

// MARK: - Preview

#Preview("Home Placeholder") {
    PlaceholderView.home()
}

#Preview("Search Placeholder") {
    PlaceholderView.search(onStartSearch: {
        LoggingService.shared.logButtonTap(button: "Start Search")
    })
}

#Preview("Loading State") {
    PlaceholderView.aiChat(isLoading: true)
} 