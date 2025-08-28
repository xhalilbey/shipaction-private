//
//  UnifiedButton.swift
//  payaction-ios
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Unified Button Style

/// Comprehensive button style variants for the application
/// 
/// Consolidates all button styles into a single, consistent design system
/// following Apple's Human Interface Guidelines and modern iOS design patterns
enum UnifiedButtonStyle {
    /// Primary action button (filled, high emphasis)
    case primary
    /// Secondary action button (subtle fill, medium emphasis)
    case secondary
    /// Secondary action button with white background (on-light surfaces)
    case secondaryWhite
    /// Outlined button (border only, medium emphasis)
    case outline
    /// Text-only button (no background, low emphasis)
    case ghost
    /// Accent color button (brand color, high emphasis)
    case accent
    
    // MARK: - Style Properties
    
    /// Background color for the button style
    var backgroundColor: Color {
        switch self {
        case .primary, .accent:
            return AppConstants.Colors.primary
        case .secondary:
            return AppConstants.Colors.surface
        case .secondaryWhite:
            return AppConstants.Colors.surfaceStrong
        case .outline, .ghost:
            return .clear
        }
    }
    
    /// Text and icon color for the button style
    var foregroundColor: Color {
        switch self {
        case .primary, .accent:
            return .white
        case .secondary, .secondaryWhite:
            return AppConstants.Colors.primary
        case .outline, .ghost:
            return AppConstants.Colors.primary
        }
    }
    
    /// Border color for the button style
    var borderColor: Color? {
        switch self {
        case .outline, .ghost:
            return AppConstants.Colors.primary
        case .secondaryWhite:
            return Color(.systemGray4).opacity(0.6)
        case .primary, .secondary, .accent:
            return nil
        }
    }
    
    /// Corner radius value for the button style
    var cornerRadius: CGFloat {
        switch self {
        case .primary, .secondary, .accent, .secondaryWhite:
            return 14
        case .outline, .ghost:
            return 12
        }
    }
    
    /// Border width for outlined styles
    var borderWidth: CGFloat {
        switch self {
        case .outline:
            return 1.0
        case .ghost:
            return 1.5
        case .secondaryWhite:
            return 1.0
        case .primary, .secondary, .accent:
            return 0
        }
    }
    
    /// Shadow configuration for elevated styles
    var hasShadow: Bool {
        switch self {
        case .primary, .accent:
            return true
        case .secondary, .outline, .ghost:
            return false
        case .secondaryWhite:
            return false
        }
    }
}

// MARK: - Unified Button Component

/// A comprehensive, reusable button component that consolidates all button variants
/// 
/// Features:
/// - Multiple predefined styles (primary, secondary, outline, ghost, accent)
/// - Loading state with activity indicator
/// - Disabled state support
/// - Optional SF Symbol icons
/// - Smooth press animations with haptic feedback
/// - Full accessibility support
/// - Modern iOS 17+ design patterns
/// 
/// Example usage:
/// ```swift
/// UnifiedButton(
///     title: "Sign In",
///     style: .primary,
///     icon: "person.fill",
///     isLoading: false,
///     isEnabled: true
/// ) {
///     // Handle button action
/// }
/// ```
struct UnifiedButton: View {
    
    // MARK: - Properties
    
    /// Button text displayed to the user
    let title: String
    
    /// Visual style variant to apply
    let style: UnifiedButtonStyle
    
    /// Optional SF Symbol name to display alongside text
    let icon: String?
    
    /// Whether to show loading indicator instead of content
    let isLoading: Bool
    
    /// Whether the button accepts user interaction
    let isEnabled: Bool
    
    /// Closure executed when button is tapped
    let action: () -> Void
    
    // MARK: - Animation State
    
    @State private var isPressed = false
    
    // MARK: - Performance Optimization
    
    private static let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - Initialization
    
    /// Creates a unified button with the specified configuration
    /// 
    /// - Parameters:
    ///   - title: Text to display on the button
    ///   - style: Visual style variant (defaults to .primary)
    ///   - icon: Optional SF Symbol name to display (defaults to nil)
    ///   - isLoading: Whether to show loading state (defaults to false)
    ///   - isEnabled: Whether button accepts interaction (defaults to true)
    ///   - action: Closure to execute on button tap
    init(
        title: String,
        style: UnifiedButtonStyle = .primary,
        icon: String? = nil,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.icon = icon
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                // Loading indicator or icon
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.9)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .imageScale(.medium)
                }
                
                // Button title
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(style.foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                    .fill(style.backgroundColor)
                    .overlay(
                        // Border for outlined styles
                        Group {
                            if let borderColor = style.borderColor {
                                RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
                                    .stroke(borderColor, lineWidth: style.borderWidth)
                            }
                        }
                    )
                    .shadow(
                        color: style.hasShadow ? .black.opacity(0.1) : .clear,
                        radius: style.hasShadow ? 8 : 0,
                        x: 0,
                        y: style.hasShadow ? 2 : 0
                    )
            )
            .opacity(isEnabled ? 1.0 : 0.4)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .disabled(!isEnabled || isLoading)
        .accessibilityLabel(title)
        .accessibilityHint("Activates \(title.lowercased()) action")
        .accessibilityIdentifier("\(title.lowercased().replacingOccurrences(of: " ", with: "_"))_button")
        .accessibilityAddTraits(.isButton)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            guard isEnabled && !isLoading else { return }
            
            isPressed = pressing
            
            // Haptic feedback on press start
            if pressing {
                Self.hapticFeedback.impactOccurred()
            }
        }, perform: {})
    }
}

// MARK: - Legacy Button Style Compatibility

/// Legacy CustomButton style enum for backward compatibility
@available(*, deprecated, message: "Use UnifiedButtonStyle instead")
enum ButtonStyle {
    case primary
    case secondary
    case outline
    case ghost
    
    var unifiedStyle: UnifiedButtonStyle {
        switch self {
        case .primary: return .primary
        case .secondary: return .secondary
        case .outline: return .outline
        case .ghost: return .ghost
        }
    }
}

/// Legacy StandardButton style enum for backward compatibility
@available(*, deprecated, message: "Use UnifiedButtonStyle instead")
enum StandardButtonStyle {
    case primary
    case secondary
    case accent
    case ghost
    
    var unifiedStyle: UnifiedButtonStyle {
        switch self {
        case .primary: return .primary
        case .secondary: return .secondary
        case .accent: return .accent
        case .ghost: return .ghost
        }
    }
}

// MARK: - Legacy Button Compatibility Wrappers

/// Legacy CustomButton wrapper for backward compatibility
@available(*, deprecated, message: "Use UnifiedButton instead")
struct CustomButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    let isLoading: Bool
    let isEnabled: Bool
    let icon: String?
    
    init(
        title: String,
        action: @escaping () -> Void,
        style: ButtonStyle = .primary,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        icon: String? = nil
    ) {
        self.title = title
        self.action = action
        self.style = style
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.icon = icon
    }
    
    var body: some View {
        UnifiedButton(
            title: title,
            style: style.unifiedStyle,
            icon: icon,
            isLoading: isLoading,
            isEnabled: isEnabled,
            action: action
        )
    }
}

/// Legacy StandardButton wrapper for backward compatibility
@available(*, deprecated, message: "Use UnifiedButton instead")
struct StandardButton: View {
    let title: String
    let style: StandardButtonStyle
    let action: () -> Void
    
    init(_ title: String, style: StandardButtonStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        UnifiedButton(
            title: title,
            style: style.unifiedStyle,
            action: action
        )
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            // Title
            VStack(spacing: 8) {
                Text("Unified Button System")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.primary)
                
                Text("Consolidated Design System")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 40)
            
            // Button Examples
            VStack(spacing: 16) {
                UnifiedButton(title: "Primary Button", style: .primary) {}
                
                UnifiedButton(title: "Secondary Button", style: .secondary) {}
                
                UnifiedButton(title: "Outline Button", style: .outline) {}
                
                UnifiedButton(title: "Ghost Button", style: .ghost) {}
                
                UnifiedButton(title: "Accent Button", style: .accent) {}
                
                UnifiedButton(
                    title: "With Icon",
                    style: .primary,
                    icon: "briefcase.fill"
                ) {}
                
                UnifiedButton(
                    title: "Loading State",
                    style: .primary,
                    isLoading: true
                ) {}
                
                UnifiedButton(
                    title: "Disabled State",
                    style: .primary,
                    isEnabled: false
                ) {}
            }
            .padding(.horizontal, 24)
            
            Spacer(minLength: 40)
        }
    }
    .background(Color(.systemGroupedBackground))
}
