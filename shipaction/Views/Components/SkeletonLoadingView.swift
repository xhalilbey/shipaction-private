//
//  SkeletonLoadingView.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Skeleton Loading View

/// Home ekranı için skeleton loading komponenti
struct HomeSkeletonLoadingView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Search section skeleton
            searchSectionSkeleton
            
            // Category chips skeleton
            categorySectionSkeleton
            
            // Content sections skeleton
            VStack(spacing: 32) {
                agentSectionSkeleton
                agentSectionSkeleton
                agentSectionSkeleton
            }
            
            Spacer()
        }
        .padding(.top, 8)
        .onAppear {
            isAnimating = true
        }
    }
    
    // MARK: - Skeleton Components
    
    private var searchSectionSkeleton: some View {
        HStack(spacing: 12) {
            // Logo placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 32, height: 32)
                .shimmer(isAnimating: isAnimating)
            
            // Search bar placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 48)
                .shimmer(isAnimating: isAnimating)
        }
        .padding(.horizontal, 20)
    }
    
    private var categorySectionSkeleton: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<5, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 32)
                        .shimmer(isAnimating: isAnimating)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var agentSectionSkeleton: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 20)
                    .shimmer(isAnimating: isAnimating)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 14)
                    .shimmer(isAnimating: isAnimating)
            }
            .padding(.horizontal, 20)
            
            // Agent cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { _ in
                        agentCardSkeleton
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var agentCardSkeleton: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Card image
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 280, height: 120)
                .shimmer(isAnimating: isAnimating)
            
            VStack(alignment: .leading, spacing: 8) {
                // Title
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 180, height: 16)
                    .shimmer(isAnimating: isAnimating)
                
                // Description
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 240, height: 12)
                    .shimmer(isAnimating: isAnimating)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 200, height: 12)
                    .shimmer(isAnimating: isAnimating)
                
                // Rating and price
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 60, height: 12)
                        .shimmer(isAnimating: isAnimating)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 40, height: 12)
                        .shimmer(isAnimating: isAnimating)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Shimmer Effect

extension View {
    func shimmer(isAnimating: Bool) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: 0)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.4),
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .scaleEffect(x: isAnimating ? 1 : 0, anchor: .leading)
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .clipped()
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Preview

#Preview {
    HomeSkeletonLoadingView()
}
