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
    private var colorScheme: ColorScheme { .light }
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
}
extension SearchTabView {
    // MARK: - Tokens
    private var backgroundColor: Color { AppConstants.Colors.background }
    
    private var headerForegroundColor: Color { AppConstants.Colors.primary }

    // MARK: - Sections
    private var header: some View {
        HStack(spacing: 12) {
            Group {
                if colorScheme == .dark { // never true
                    Image("white_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(AppConstants.Colors.primary)
                }
            }
            .frame(width: 28, height: 28)
            .accessibilityHidden(true)
            
            Text("Shipaction")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(headerForegroundColor)
                .accessibilityIdentifier("brand_title")
            
            Spacer()
            
            // Share button (placeholder, inactive for now) - subtle, no fill
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(headerForegroundColor)
            }
            .buttonStyle(.plain)
            .allowsHitTesting(false) // inactive for now
            .accessibilityLabel("Share app")
            .accessibilityHint("Coming soon")
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
    }

    private var categoryList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)
                .foregroundStyle(.primary)
            
            VStack(spacing: 8) {
                ForEach(Array(viewModel.availableCategories.indices), id: \.self) { index in
                    let item = viewModel.availableCategories[index]
                    CategoryRow(
                        category: item.category,
                        isSelected: viewModel.selectedCategory == item.category,
                        namespace: categoryNamespace
                    ) {
                        HapticFeedbackManager.shared.playSelection()
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                            viewModel.toggleCategory(item.category)
                        }
                    }
                    .opacity(appearedCategoryIds.contains(item.category.rawValue) ? 1 : 0)
                    .offset(y: appearedCategoryIds.contains(item.category.rawValue) ? 0 : 8)
                    .task {
                        if !appearedCategoryIds.contains(item.category.rawValue) {
                            try? await Task.sleep(nanoseconds: UInt64(index) * 40_000_000)
                            withAnimation(.easeOut(duration: 0.25)) {
                                appearedCategoryIds.insert(item.category.rawValue)
                            }
                        }
                    }
                }
            }
        }
    }

    private var agentResults: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.selectedCategory?.displayName ?? "All Agents")
                    .font(.headline)
                Spacer()
                if viewModel.selectedCategory != nil {
                    Button("Clear") { viewModel.clearFilters() }
                        .font(.subheadline)
                        .foregroundStyle(AppConstants.Colors.primary)
                }
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredAgents) { agent in
                    SearchResultCard(
                        result: SearchResult(
                            title: agent.name,
                            description: agent.description,
                            type: agent.category.displayName
                        )
                    )
                }
            }
        }
    }
}

// MARK: - Search Result Card

struct SearchResultCard: View {
    let result: SearchResult
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(AppConstants.Colors.primary)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(surfaceColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(AppConstants.Colors.primary.opacity(0.06), lineWidth: 1)
                        )
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(result.title)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(result.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(surfaceStrongColor)
        )
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
    }

    private var surfaceColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.06) : AppConstants.Colors.surface
    }

    private var surfaceStrongColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : AppConstants.Colors.surfaceStrong
    }
}

// MARK: - Helpers

private struct IfLetNamespace: ViewModifier {
    let namespace: Namespace.ID?
    let id: String

    func body(content: Content) -> some View {
        if let ns = namespace {
            content.matchedGeometryEffect(id: id, in: ns)
        } else {
            content
        }
    }
}

// MARK: - Category Row

private struct CategoryRow: View {
    let category: AgentCategory
    let isSelected: Bool
    let onTap: () -> Void
    var namespace: Namespace.ID?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationLink(value: category) {
            ZStack {
                if isSelected, let ns = namespace {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(categoryCardBackground)
                        .matchedGeometryEffect(id: "row-bg-\(category.rawValue)", in: ns)
                }
                HStack(spacing: 12) {
                    Group {
                        if let ns = namespace, isSelected {
                            Image(systemName: category.iconName)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(categoryIconForeground)
                                .frame(width: 36, height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(categoryIconBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                                .stroke(AppConstants.Colors.primary.opacity(0.06), lineWidth: 1)
                                        )
                                )
                                .matchedGeometryEffect(id: "icon-\(category.rawValue)", in: ns, isSource: true)
                        } else {
                            Image(systemName: category.iconName)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(categoryIconForeground)
                                .frame(width: 36, height: 36)
                                .background(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(categoryIconBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                                .stroke(AppConstants.Colors.primary.opacity(0.06), lineWidth: 1)
                                        )
                                )
                        }
                    }

                    Text(category.displayName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: isSelected ? "checkmark.circle.fill" : "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(trailingIndicatorColor(isSelected: isSelected))
                }
                .padding(14)
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(rowBaseBackground(isSelected: isSelected))
            )
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: isSelected)
    }

    private var surfaceColor: Color { AppConstants.Colors.surface }

    private var surfaceStrongColor: Color { AppConstants.Colors.surfaceStrong }

    // Category card background specifically requested as #A84B2F in dark mode (no opacity)
    private var categoryCardBackground: Color {
        colorScheme == .dark ? Color(hex: "A84B2F") : surfaceStrongColor
    }

    private var categoryIconForeground: Color {
        colorScheme == .dark ? .white : AppConstants.Colors.primary
    }

    private var categoryIconBackground: Color {
        colorScheme == .dark ? Color.white.opacity(0.12) : surfaceColor
    }

    private func trailingIndicatorColor(isSelected: Bool) -> Color {
        if colorScheme == .dark {
            return isSelected ? .white : .secondary
        } else {
            return isSelected ? AppConstants.Colors.primary : .secondary
        }
    }

    private func rowBaseBackground(isSelected: Bool) -> Color {
        if colorScheme == .dark {
            return isSelected ? categoryCardBackground.opacity(0.001) : categoryCardBackground
        } else {
            return isSelected ? surfaceStrongColor.opacity(0.001) : surfaceStrongColor
        }
    }
}

// MARK: - Agent List View

private struct AgentListView: View {
    let category: AgentCategory
    let agents: [Agent]
    var namespace: Namespace.ID?
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(agents) { agent in
                    AgentCard(agent: agent) { _ in
                        // Placeholder action for search context
                        print("Start tapped: \(agent.name)")
                    }
                }
            }
            .padding(16)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { _ = navigationBack() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AppConstants.Colors.primary)
                        Text("Back")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AppConstants.Colors.primary)
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                if let ns = namespace {
                    HStack(spacing: 8) {
                        Image(systemName: category.iconName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AppConstants.Colors.primary)
                            .matchedGeometryEffect(id: "icon-\(category.rawValue)", in: ns, isSource: false)
                        Text(category.displayName)
                            .font(.system(size: 18, weight: .semibold))
                    }
                } else {
                    Text(category.displayName)
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(backgroundColor)
    }
    
    @Environment(\.dismiss) private var dismiss
    private func navigationBack() -> Bool { dismiss(); return true }

    private var backgroundColor: Color { AppConstants.Colors.background }
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