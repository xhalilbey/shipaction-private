//
//  LoadingView.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Loading View

/// Uygulama açılış ekranı - sadece merkezi logo
struct LoadingView: View {
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Brand background
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            // Logo + subtle pulse to indicate activity
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .symbolEffect(.pulse, options: .repeating)
        }
    }
}

// MARK: - Loading View with Custom Message

/// Sayfa içi loading için kullanılacak (sadece logo)
struct LoadingViewWithMessage: View {
    
    let message: String
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Brand background
            AppConstants.Colors.background
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .symbolEffect(.pulse, options: .repeating)
                
                Text(message)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(AppConstants.Colors.primary)
            }
        }
    }
}

// MARK: - Preview

#Preview("Default Loading") {
    LoadingView()
}

#Preview("Custom Message") {
    LoadingViewWithMessage(message: "Setting up your account...")
}
