//
//  LibraryTabView.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Library Tab View

/// Base tab view - Simple base page
struct LibraryTabView: View {
    
    // MARK: - Properties
    
    @Bindable var viewModel: LibraryViewModel
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                
                // Base Page Content
                VStack {
                    Spacer()
                    Text("Base sayfası")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                    Spacer()
                }
            }
            .background(backgroundColor)
        }
    }
}

// MARK: - Tokens
private extension LibraryTabView {
    var backgroundColor: Color { 
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
    
    // MARK: - Header
    var header: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Group {
                    Image(AppConstants.Colors.dynamicLogo(colorScheme))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(AppConstants.Colors.primary)
                }
                .frame(width: 28, height: 28)
                .accessibilityHidden(true)

                Text("Base")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}