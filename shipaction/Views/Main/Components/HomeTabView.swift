//
//  HomeTabView.swift
//  shipaction
//
//  Created by Assistant on 06.08.2025.
//

import SwiftUI

// MARK: - Home Tab View

/// Home/Dashboard tab view - AI Agent Marketplace
struct HomeTabView: View {
    
    // MARK: - Properties
    
    @Bindable var viewModel: HomeViewModel
    @State private var searchText = ""
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.isLoading {
                    // Tüm ekran skeleton loading
                    HomeSkeletonLoadingView()
                } else {
                    LazyVStack(spacing: 24) {
                        searchSection
                        categorySection
                        contentSection
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }
            .background(homeBackground)
            .refreshable {
                await viewModel.refreshAgents()
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadAgents()
        }
    }
    
    // MARK: - Sections
    
    private var searchSection: some View {
        HStack(spacing: 12) {
            Image(AppConstants.Colors.dynamicLogo(colorScheme))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(searchIconColor)

                TextField(
                    "",
                    text: $searchText,
                    prompt: Text("Search agents...")
                        .foregroundStyle(searchPromptColor)
                )
                .font(.system(size: 16, weight: .regular))
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundStyle(searchTextColor)
                .onChange(of: searchText) { _, newValue in
                    viewModel.searchQuery = newValue
                }

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        viewModel.searchQuery = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(searchIconColor)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(searchFieldBackground)
            )
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private var categorySection: some View {
        if !viewModel.availableCategories.isEmpty {
            CategoryFilterChips(
                categories: viewModel.availableCategories,
                selectedCategory: $viewModel.selectedCategory
            )
        }
    }
    
    @ViewBuilder
    private var contentSection: some View {
        if let errorMessage = viewModel.errorMessage {
            errorView(errorMessage)
        } else {
            agentSections
        }
    }
    
    private var agentSections: some View {
        VStack(spacing: 32) {
            agentSection(
                title: "Most Used",
                subtitle: "Most popular AI agents by usage",
                agents: viewModel.mostUsedAgents
            )
            
            agentSection(
                title: "Recommended",
                subtitle: "Hand-picked agents for you",
                agents: viewModel.recommendedAgents
            )
            
            agentSection(
                title: "Best Performance",
                subtitle: "Top-rated agents with excellent performance",
                agents: viewModel.bestPerformingAgents
            )
        }
    }
    
    @ViewBuilder
    private func agentSection(
        title: String,
        subtitle: String,
        agents: [Agent]
    ) -> some View {
        if !agents.isEmpty {
            CategorySection(
                title: title,
                subtitle: subtitle,
                agents: agents,
                onAgentStart: { agent in
                    viewModel.startAgent(agent)
                },
                onAgentDetail: { agent in
                    // TODO: Navigate to agent detail view
                    print("Show details for agent: \(agent.name)")
                }
            )
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 32, weight: .light))
                .foregroundStyle(.orange)
            
            Text(message)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again") {
                Task {
                    await viewModel.loadAgents()
                }
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppConstants.Colors.primary)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 20)
    }
}

// MARK: - Dark Mode Helpers

extension HomeTabView {
    private var homeBackground: Color { 
        AppConstants.Colors.dynamicBackground(colorScheme)
    }
    private var searchIconColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.8) : Color.gray.opacity(0.7)
    }
    private var searchPromptColor: Color {
        AppConstants.Colors.dynamicSecondaryText(colorScheme)
    }
    private var searchTextColor: Color {
        AppConstants.Colors.dynamicPrimaryText(colorScheme)
    }
    private var searchFieldBackground: Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1)
    }
}
