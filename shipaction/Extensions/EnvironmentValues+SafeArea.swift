//
//  EnvironmentValues+SafeArea.swift
//  payaction-ios
//
//  Created by Halil Eren on 14.06.2025.
//

import SwiftUI
import UIKit

// MARK: - Environment Values Safe Area Extension

/// Extends EnvironmentValues to provide safe area insets access.
/// 
/// This extension allows SwiftUI views to access the current window's
/// safe area insets for proper layout positioning around system UI elements
/// like the notch, home indicator, and status bar.
extension EnvironmentValues {
    
    /// Computed property that returns the current safe area insets.
    /// 
    /// - Returns: EdgeInsets representing safe area margins, or zero if unavailable
    /// - Note: Falls back to zero insets if window scene is not available
    /// 
    /// Example usage:
    /// ```swift
    /// struct MyView: View {
    ///     @Environment(\.safeAreaInsets) private var safeAreaInsets
    ///     
    ///     var body: some View {
    ///         VStack {
    ///             // Content
    ///         }
    ///         .padding(.bottom, safeAreaInsets.bottom)
    ///     }
    /// }
    /// ```
    var safeAreaInsets: EdgeInsets {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return EdgeInsets()
        }
        
        let safeArea = window.safeAreaInsets
        return EdgeInsets(
            top: safeArea.top,
            leading: safeArea.left,
            bottom: safeArea.bottom,
            trailing: safeArea.right
        )
    }
}