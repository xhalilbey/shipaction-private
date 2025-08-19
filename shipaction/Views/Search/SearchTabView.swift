//
//  SearchTabView.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Search Tab View

/// Search tab – category-first filtering UI
struct SearchTabView: View {
    
    // MARK: - Properties
    
    @Bindable var viewModel: SearchViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Namespace private var categoryNamespace
    @State private var appearedCategoryIds: Set<String> = []
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    if viewModel.isLoading {
                        CategorySkeletonView()
                    } else {
                        categoryList
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
            .background(backgroundColor)
            .task { await viewModel.load() }
            .navigationDestination(for: AgentCategory.self) { category in
                AgentListView(
                    category: category,
                    agents: viewModel.agents.filter { $0.category == category },
                    namespace: categoryNamespace
                )
            }
            .tint(AppConstants.Colors.primary)
            .animation(.spring(response: 0.45, dampingFraction: 0.85), value: viewModel.selectedCategory)
        }
    }
    
    // MARK: - Subviews
    
    private var header: some View {
        VStack(spacing: 16) {
            // Logo and brand section
            HStack(spacing: 12) {
                Spacer(minLength: 0)
                
                Image(AppConstants.Colors.dynamicLogo(colorScheme))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .accessibilityHidden(true)
                
                Text("Nexor")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                    .accessibilityIdentifier("brand_title")
                
                Spacer(minLength: 0)
                
                // Share button (placeholder, inactive for now) - subtle, no fill
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(AppConstants.Colors.dynamicPrimaryText(colorScheme))
                }
                .buttonStyle(.plain)
                .allowsHitTesting(false) // inactive for now
                .accessibilityLabel("Share app")
                .accessibilityHint("Coming soon")
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            
            Text("Browse by Category")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private var categoryList: some View {
        if viewModel.isEmpty && !viewModel.searchQuery.isEmpty {
            emptySearchState
        } else if !viewModel.isEmpty {
            VStack(spacing: 8) {
                ForEach(Array(viewModel.availableCategories.indices), id: \.self) { index in
                    let item = viewModel.availableCategories[index]
                    CategoryRow(
                        category: item.category,
                        isSelected: viewModel.selectedCategory == item.category,
                        onTap: {
                            HapticFeedbackManager.shared.playSelection()
                            viewModel.selectedCategory = item.category
                        },
                        namespace: categoryNamespace
                    )
                    .onAppear {
                        animateCategoryAppearance(item.category, delay: Double(index) * 0.05)
                    }
                    .scaleEffect(appearedCategoryIds.contains(item.category.rawValue) ? 1 : 0.8)
                    .opacity(appearedCategoryIds.contains(item.category.rawValue) ? 1 : 0)
                }
            }
            .padding(.bottom, 20)
        } else {
            emptyState
        }
    }
    
    private var emptySearchState: some View {
        Text("No categories found")
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var emptyState: some View {
        PlaceholderView(
            title: "No Categories Available",
            description: "Check back later for agent categories",
            iconName: "folder"
        )
        .frame(maxWidth: .infinity, minHeight: 400)
    }
    
    // MARK: - Helpers
    
    private func animateCategoryAppearance(_ category: AgentCategory, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                _ = appearedCategoryIds.insert(category.rawValue)
            }
        }
    }
    
    // MARK: - Colors
    
    private var backgroundColor: Color { 
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
}

// MARK: - Category Skeleton View

private struct CategorySkeletonView: View {
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<6, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(skeletonFillColor)
                    .frame(height: 56)
                    .shimmer(isAnimating: isAnimating)
            }
        }
        .onAppear { isAnimating = true }
    }

    private var skeletonFillColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color.gray.opacity(0.18)
    }
}
